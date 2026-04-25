import SwiftUI

struct YearProgressView: View {
    // Shared Settings
    @AppStorage("textColorHex") private var textColorHex: String = "FFFFFF"
    @AppStorage("shadowColorHex") private var shadowColorHex: String = "000000"
    @AppStorage("shadowRadius") private var shadowRadius: Double = 4.0
    @AppStorage("shadowOpacity") private var shadowOpacity: Double = 0.5
    @AppStorage("shadowOffsetY") private var shadowOffsetY: Double = 2.0
    
    // Year Settings
    @AppStorage("yearPtcSize") private var yearPtcSize: Double = 100.0
    @AppStorage("yearGridWidth") private var yearGridWidth: Double = 300.0
    @AppStorage("yearDotSize") private var yearDotSize: Double = 8.0
    @AppStorage("yearDotSpacing") private var yearDotSpacing: Double = 4.0
    @AppStorage("yearPctPosition") private var yearPctPosition: String = "top"
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { _ in
            let progress = YearProgressLogic.currentYearProgress()
            
            YearContentView(
                percentage: progress.percentage,
                dayOfYear: progress.dayOfYear,
                daysInYear: progress.daysInYear,
                yearPtcSize: yearPtcSize,
                yearGridWidth: yearGridWidth,
                yearDotSize: yearDotSize,
                yearDotSpacing: yearDotSpacing,
                yearPctPosition: yearPctPosition,
                textColorHex: textColorHex,
                shadowColorHex: shadowColorHex,
                shadowRadius: shadowRadius,
                shadowOpacity: shadowOpacity,
                shadowOffsetY: shadowOffsetY
            )
        }
    }
}
