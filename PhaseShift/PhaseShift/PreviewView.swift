import SwiftUI

struct PreviewView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    // Dummy Data for Preview
    let dummyAge = AgeComponents(years: 25, months: 6, weeks: 2, days: 14, hours: 10, minutes: 45, seconds: 30)
    
    // 16:9 Aspect Ratio
    let previewWidth: CGFloat = 460
    
    var mainScreenFrame: CGRect {
        NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1920, height: 1080)
    }
    
    var previewHeight: CGFloat {
        previewWidth * (mainScreenFrame.height / mainScreenFrame.width)
    }
    
    var scaleFactor: CGFloat {
        previewWidth / mainScreenFrame.width
    }

    var body: some View {
        ZStack {
            // Background: Solid Dark (Reverted as requested)
            Color.black
            
            // Content
            Group {
                if viewModel.viewMode == "age" {
                   previewAgeView
                } else {
                   previewYearView
                }
            }
            // Base resolution frame
            .frame(width: mainScreenFrame.width, height: mainScreenFrame.height)
            .offset(x: viewModel.offsetX, y: viewModel.offsetY)
            .scaleEffect(scaleFactor)
        }
        .frame(width: previewWidth, height: previewHeight)
        .cornerRadius(8)
        .clipped()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    var previewAgeView: some View {
        TimelineView(.periodic(from: .now, by: 0.1)) { context in
            let detailed = AgeCalculator.calculateDetailedAge(from: viewModel.birthDate, to: context.date)
            let yearStr = "\(detailed.year)"
            let compStr = String(format: "%02d%02d%02d%02d%02d%02d",
                                 detailed.month, detailed.week, detailed.day,
                                 detailed.hour, detailed.minute, detailed.second)
            
            AgeContentView(
                yearString: yearStr,
                componentsString: compStr,
                yearSize: viewModel.yearSize,
                componentScale: viewModel.componentScale,
                labelSpacing: viewModel.labelSpacing,
                fontDesignStr: viewModel.fontDesign,
                textColorHex: viewModel.textColorHex,
                shadowColorHex: viewModel.shadowColorHex,
                shadowRadius: viewModel.shadowRadius,
                shadowOpacity: viewModel.shadowOpacity,
                shadowOffsetY: viewModel.shadowOffsetY
            )
        }
    }
    
    var previewYearView: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { _ in
            let progress = YearProgressLogic.currentYearProgress()
            
            YearContentView(
                percentage: progress.percentage,
                dayOfYear: progress.dayOfYear,
                daysInYear: progress.daysInYear,
                yearPtcSize: viewModel.yearPtcSize,
                yearGridWidth: viewModel.yearGridWidth,
                yearDotSize: viewModel.yearDotSize,
                yearDotSpacing: viewModel.yearDotSpacingLocal,
                yearPctPosition: viewModel.yearPctPosition,
                textColorHex: viewModel.textColorHex,
                shadowColorHex: viewModel.shadowColorHex,
                shadowRadius: viewModel.shadowRadius,
                shadowOpacity: viewModel.shadowOpacity,
                shadowOffsetY: viewModel.shadowOffsetY
            )
        }
    }
}
