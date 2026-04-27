#!/bin/bash

# --- CONFIGURATION ---
PROJECT_NAME="PhaseShift"
SCHEME_NAME="PhaseShift"
# The script will now look for the key in your macOS Keychain automatically.
# No secret strings are stored in this file anymore.
BUILD_DIR="PhaseShift/build"
APP_PATH="${BUILD_DIR}/Build/Products/Release/${PROJECT_NAME}.app"
SPARKLE_BIN="${BUILD_DIR}/SourcePackages/artifacts/sparkle/Sparkle/bin"

# 1. Clean and Build
echo "🚀 Building ${PROJECT_NAME} in Release mode..."
xcodebuild build -project PhaseShift/${PROJECT_NAME}.xcodeproj -scheme ${SCHEME_NAME} -configuration Release -derivedDataPath ${BUILD_DIR} CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO -quiet

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# 2. Extract Version Info
VERSION=$(defaults read "$(pwd)/${APP_PATH}/Contents/Info.plist" CFBundleShortVersionString)
BUILD_VERSION=$(defaults read "$(pwd)/${APP_PATH}/Contents/Info.plist" CFBundleVersion)
echo "📦 Detected Version: ${VERSION} (${BUILD_VERSION})"

# 3. DEEP SIGN (The Critical Fix)
echo "🔐 Applying Deep Ad-Hoc Signature..."
codesign --force --deep -s - "${APP_PATH}"

# 4. Create ZIP for Sparkle
ZIP_NAME="${PROJECT_NAME}_v${VERSION}.zip"
echo "zip -ry ${ZIP_NAME} ${APP_PATH}"
rm -f "${ZIP_NAME}"
zip -ry "${ZIP_NAME}" "${APP_PATH}" > /dev/null

# 5. Sign the ZIP
echo "✍️ Signing ZIP with EdDSA..."
SIGNATURE_INFO=$("${SPARKLE_BIN}/sign_update" "${ZIP_NAME}")
# Extract signature and length from output
ED_SIGNATURE=$(echo "${SIGNATURE_INFO}" | grep -o 'sparkle:edSignature="[^"]*"' | cut -d'"' -f2)
FILE_LENGTH=$(echo "${SIGNATURE_INFO}" | grep -o 'length="[^"]*"' | cut -d'"' -f2)

if [ -z "${ED_SIGNATURE}" ]; then
    echo "❌ Signing failed!"
    exit 1
fi

# 6. Update appcast.xml
echo "📝 Updating appcast.xml..."
PUB_DATE=$(date -u +"%a, %d %b %Y %H:%M:%S +0000")
ITEM_CONTENT="    <item>\n      <title>Version ${VERSION}</title>\n      <pubDate>${PUB_DATE}</pubDate>\n      <sparkle:minimumSystemVersion>12.0</sparkle:minimumSystemVersion>\n      <enclosure url=\"https://github.com/AtharvaBari/PhaseShift-MacOS/releases/download/v${VERSION}/${ZIP_NAME}\" sparkle:edSignature=\"${ED_SIGNATURE}\" sparkle:version=\"${BUILD_VERSION}\" sparkle:shortVersionString=\"${VERSION}\" length=\"${FILE_LENGTH}\" type=\"application/zip\"></enclosure>\n    </item>"

# Use python to insert the new item after the <language> tag
python3 -c "
import sys
content = open('appcast.xml').read()
new_item = \"\"\"${ITEM_CONTENT}\"\"\"
if 'Version ${VERSION}' not in content:
    updated = content.replace('<language>en</language>', '<language>en</language>\\n' + new_item)
    open('appcast.xml', 'w').write(updated)
    print('✅ Appcast updated.')
else:
    print('⚠️ Version already exists in appcast.')
"

# 7. Sign the appcast.xml itself
echo "🔏 Sealing appcast.xml..."
"${SPARKLE_BIN}/sign_update" appcast.xml > /dev/null

# 8. Create DMG for Manual Install (Optional)
DMG_NAME="phaseshift_v${VERSION}.dmg"
echo "💿 Creating DMG: ${DMG_NAME}..."
rm -rf dmg_staging && mkdir -p dmg_staging
cp -R "${APP_PATH}" dmg_staging/
ln -s /Applications dmg_staging/Applications
hdiutil create -volname "${PROJECT_NAME} v${VERSION}" -srcfolder dmg_staging -ov -format UDZO "${DMG_NAME}" > /dev/null
rm -rf dmg_staging

echo "--------------------------------------------------"
echo "✅ SUCCESS! v${VERSION} is ready for release."
echo "1. Upload ${ZIP_NAME} and ${DMG_NAME} to GitHub Releases."
echo "2. Run: git add . && git commit -m \"Release v${VERSION}\" && git push"
echo "--------------------------------------------------"
