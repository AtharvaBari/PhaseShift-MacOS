import SwiftUI

struct AgeContentView: View {
    var yearString: String
    var componentsString: String
    var yearSize: Double
    var componentScale: Double
    var labelSpacing: Double
    var fontDesignStr: String
    var textColorHex: String
    var shadowColorHex: String
    var shadowRadius: Double
    var shadowOpacity: Double
    var shadowOffsetY: Double
    
    var body: some View {
        let textColor = Color(hex: textColorHex)
        let shadowColor = Color(hex: shadowColorHex).opacity(shadowOpacity)
        
        let design: Font.Design = {
            switch fontDesignStr {
            case "rounded": return .rounded
            case "serif": return .serif
            case "monospaced": return .monospaced
            default: return .default
            }
        }()
        
        VStack(alignment: .leading, spacing: labelSpacing) {
            Text("AGE")
                .font(.system(size: yearSize * 0.25, weight: .bold, design: design))
                .foregroundColor(textColor.opacity(0.8))
                .shadow(color: shadowColor, radius: shadowRadius / 2, x: 0, y: shadowOffsetY / 2)
                .padding(.leading, 4)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(yearString)
                    .font(.system(size: yearSize, weight: .bold, design: design))
                    .foregroundColor(textColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
                
                Text(".")
                    .font(.system(size: yearSize, weight: .bold, design: design))
                    .foregroundColor(textColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
                
                Text(componentsString)
                    .font(.system(size: yearSize * componentScale, weight: .bold, design: .monospaced))
                    .foregroundColor(textColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
            }
        }
    }
}

struct YearContentView: View {
    var percentage: Double
    var dayOfYear: Int
    var daysInYear: Int
    
    var yearPtcSize: Double
    var yearGridWidth: Double
    var yearDotSize: Double
    var yearDotSpacing: Double
    var yearPctPosition: String
    var textColorHex: String
    var shadowColorHex: String
    var shadowRadius: Double
    var shadowOpacity: Double
    var shadowOffsetY: Double
    
    var body: some View {
        let textColor = Color(hex: textColorHex)
        let shadowColor = Color(hex: shadowColorHex).opacity(shadowOpacity)
        
        let columns = [GridItem(.adaptive(minimum: yearDotSize, maximum: yearDotSize * 2), spacing: yearDotSpacing)]
        
        let percentageView = Text(String(format: "%.1f%%", percentage))
            .font(.system(size: yearPtcSize, weight: .bold, design: .default))
            .foregroundColor(textColor)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffsetY)
        
        let gridView = LazyVGrid(columns: columns, spacing: yearDotSpacing) {
            ForEach(1...daysInYear, id: \.self) { day in
                Circle()
                    .fill(day <= dayOfYear ? textColor.opacity(1.0) : textColor.opacity(0.3)) 
                    .frame(width: yearDotSize, height: yearDotSize)
                    .shadow(color: day <= dayOfYear ? shadowColor : .clear, radius: 2)
            }
        }
        .frame(width: yearGridWidth)
        
        Group {
            switch yearPctPosition {
            case "topLeading": VStack(alignment: .leading, spacing: 10) { percentageView; gridView }
            case "top": VStack(spacing: 10) { percentageView; gridView }
            case "topTrailing": VStack(alignment: .trailing, spacing: 10) { percentageView; gridView }
            case "bottomLeading": VStack(alignment: .leading, spacing: 10) { gridView; percentageView }
            case "bottom": VStack(spacing: 10) { gridView; percentageView }
            case "bottomTrailing": VStack(alignment: .trailing, spacing: 10) { gridView; percentageView }
            case "left": HStack(spacing: 15) { percentageView; gridView }
            case "right": HStack(spacing: 15) { gridView; percentageView }
            default: VStack(spacing: 10) { percentageView; gridView }
            }
        }
    }
}
