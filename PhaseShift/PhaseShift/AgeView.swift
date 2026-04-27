import SwiftUI

struct AgeView: View {
    @AppStorage("birthDate") private var birthDateTimestamp: Double = Date().timeIntervalSince1970
    
    // TYPOGRAPHY settings
    @AppStorage("yearSize") private var yearSize: Double = 100.0
    @AppStorage("componentScale") private var componentScale: Double = 0.5
    @AppStorage("labelSpacing") private var labelSpacing: Double = -5.0
    @AppStorage("fontDesign") private var fontDesignStr: String = "default"
    
    // COLORS
    @AppStorage("textColorHex") private var textColorHex: String = "FFFFFF"
    @AppStorage("shadowColorHex") private var shadowColorHex: String = "000000"
    
    // EFFECTS
    @AppStorage("shadowRadius") private var shadowRadius: Double = 4.0
    @AppStorage("shadowOpacity") private var shadowOpacity: Double = 0.5
    @AppStorage("shadowOffsetY") private var shadowOffsetY: Double = 2.0
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.1)) { context in
            let detailed = AgeCalculator.calculateDetailedAge(from: Date(timeIntervalSince1970: birthDateTimestamp), to: context.date)
            let yearStr = "\(detailed.year)"
            let compStr = String(format: "%02d%02d%02d%02d%02d%02d",
                                 detailed.month, detailed.week, detailed.day,
                                 detailed.hour, detailed.minute, detailed.second)
            
            AgeContentView(
                yearString: yearStr,
                componentsString: compStr,
                yearSize: yearSize,
                componentScale: componentScale,
                labelSpacing: labelSpacing,
                fontDesignStr: fontDesignStr,
                textColorHex: textColorHex,
                shadowColorHex: shadowColorHex,
                shadowRadius: shadowRadius,
                shadowOpacity: shadowOpacity,
                shadowOffsetY: shadowOffsetY
            )
        }
    }
}
