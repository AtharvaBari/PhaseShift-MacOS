import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    // published properties (Staged State)
    @Published var birthDate: Date = Date()
    @Published var displayMode: Int = -1
    @Published var viewMode: String = "age"
    
    @Published var yearSize: Double = 100.0
    @Published var componentScale: Double = 0.5
    @Published var labelSpacing: Double = -5.0
    @Published var fontDesign: String = "default"
    @Published var offsetX: Double = 0.0
    @Published var offsetY: Double = 0.0
    
    @Published var yearPtcSize: Double = 100.0
    @Published var yearGridWidth: Double = 300.0
    @Published var yearDotSize: Double = 8.0
    @AppStorage("yearDotSpacing") var yearDotSpacing: Double = 4.0 // Bound to AppStorage
    
    @Published var yearDotSpacingLocal: Double = 4.0
    @Published var yearPctPosition: String = "top"
    
    @Published var textColorHex: String = "FFFFFF"
    @Published var shadowColorHex: String = "000000"
    @Published var shadowRadius: Double = 4.0
    @Published var shadowOpacity: Double = 0.5
    @Published var shadowOffsetY: Double = 2.0
    
    // Track initial state to detect changes requiring restart
    private var initialDisplayMode: Int = -1
    
    // Initializer loads from UserDefaults
    init() {
        loadFromDefaults()
    }
    
    func loadFromDefaults() {
        let d = UserDefaults.standard
        birthDate = Date(timeIntervalSince1970: d.double(forKey: "birthDate"))
        if birthDate.timeIntervalSince1970 == 0 { birthDate = Date() }
        
        displayMode = d.integer(forKey: "displayMode")
        if d.object(forKey: "displayMode") == nil { displayMode = -1 }
        initialDisplayMode = displayMode
        
        viewMode = d.string(forKey: "viewMode") ?? "age"
        
        yearSize = d.double(forKey: "yearSize"); if yearSize == 0 { yearSize = 100.0 }
        componentScale = d.double(forKey: "componentScale"); if componentScale == 0 { componentScale = 0.5 }
        labelSpacing = d.double(forKey: "labelSpacing"); if labelSpacing == 0 { labelSpacing = -5.0 }
        fontDesign = d.string(forKey: "fontDesign") ?? "default"
        offsetX = d.double(forKey: "offsetX")
        offsetY = d.double(forKey: "offsetY")
        
        yearPtcSize = d.double(forKey: "yearPtcSize"); if yearPtcSize == 0 { yearPtcSize = 100.0 }
        yearGridWidth = d.double(forKey: "yearGridWidth"); if yearGridWidth == 0 { yearGridWidth = 300.0 }
        yearDotSize = d.double(forKey: "yearDotSize"); if yearDotSize == 0 { yearDotSize = 8.0 }
        yearDotSpacingLocal = d.double(forKey: "yearDotSpacing"); if yearDotSpacingLocal == 0 { yearDotSpacingLocal = 4.0 }
        yearPctPosition = d.string(forKey: "yearPctPosition") ?? "top"
        
        textColorHex = d.string(forKey: "textColorHex") ?? "FFFFFF"
        shadowColorHex = d.string(forKey: "shadowColorHex") ?? "000000"
        shadowRadius = d.double(forKey: "shadowRadius"); if shadowRadius == 0 { shadowRadius = 4.0 }
        shadowOpacity = d.double(forKey: "shadowOpacity"); if shadowOpacity == 0 { shadowOpacity = 0.5 }
        shadowOffsetY = d.double(forKey: "shadowOffsetY"); if shadowOffsetY == 0 { shadowOffsetY = 2.0 }
    }
    
    func save() -> Bool {
        let d = UserDefaults.standard
        d.set(birthDate.timeIntervalSince1970, forKey: "birthDate")
        d.set(displayMode, forKey: "displayMode")
        d.set(viewMode, forKey: "viewMode")
        d.set(yearSize, forKey: "yearSize")
        d.set(componentScale, forKey: "componentScale")
        d.set(labelSpacing, forKey: "labelSpacing")
        d.set(fontDesign, forKey: "fontDesign")
        d.set(offsetX, forKey: "offsetX")
        d.set(offsetY, forKey: "offsetY")
        d.set(yearPtcSize, forKey: "yearPtcSize")
        d.set(yearGridWidth, forKey: "yearGridWidth")
        d.set(yearDotSize, forKey: "yearDotSize")
        d.set(yearDotSpacingLocal, forKey: "yearDotSpacing")
        d.set(yearPctPosition, forKey: "yearPctPosition")
        d.set(textColorHex, forKey: "textColorHex")
        d.set(shadowColorHex, forKey: "shadowColorHex")
        d.set(shadowRadius, forKey: "shadowRadius")
        d.set(shadowOpacity, forKey: "shadowOpacity")
        d.set(shadowOffsetY, forKey: "shadowOffsetY")
        
        initialDisplayMode = displayMode
        
        // Post notification so AppDelegate recreates windows without restart
        NotificationCenter.default.post(name: NSNotification.Name("SettingsApplied"), object: nil)
        
        // Never require a restart
        return false
    }
    
    func revert() {
        loadFromDefaults()
    }
    
    func applyTheme(_ theme: ThemePreset) {
        textColorHex = theme.textColorHex
        shadowColorHex = theme.shadowColorHex
        shadowRadius = theme.shadowRadius
        shadowOpacity = theme.shadowOpacity
        shadowOffsetY = theme.shadowOffsetY
        fontDesign = theme.fontDesign
    }
    
    func resetToDefaults() {
        birthDate = Date()
        displayMode = -1
        viewMode = "age"
        
        yearSize = 100.0
        componentScale = 0.5
        labelSpacing = -5.0
        fontDesign = "default"
        offsetX = 0.0
        offsetY = 0.0
        
        yearPtcSize = 100.0
        yearGridWidth = 300.0
        yearDotSize = 8.0
        yearDotSpacingLocal = 4.0
        yearPctPosition = "top"
        
        textColorHex = "FFFFFF"
        shadowColorHex = "000000"
        shadowRadius = 4.0
        shadowOpacity = 0.5
        shadowOffsetY = 2.0
    }
}
