# 🚀 PhaseShift v2.0.7 - Deep Code Signature Fix

This release introduces a deep Ad-Hoc code signature to satisfy Sparkle's strict code-signing validation layer.

## 📝 What’s New
* **Code Signature Seal**: Applied `--deep` Ad-Hoc code signing to the app bundle to ensure `Info.plist` and all resources are properly sealed, resolving the "Improperly Signed" error caused by mismatched signature hashes.
* **Appcast Signature**: Maintained the signed XML feed for maximum security compatibility with Sparkle 2.x.

## ⚙️ How to Update
If you are on an older version, please install the newly provided `v2.0.7` DMG manually. This will establish the correct deep-signature baseline for all future automated updates.

---
*“Success is built on a foundation of persistence.”*
