import Foundation

struct ThemePreset: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    
    // Colors
    let textColorHex: String
    let shadowColorHex: String
    
    // Effects
    let shadowRadius: Double
    let shadowOpacity: Double
    let shadowOffsetY: Double
    
    // Typography
    let fontDesign: String
    
    static let allPresets: [ThemePreset] = [
        ThemePreset(
            id: "default",
            name: "Classic White",
            icon: "circle.fill",
            textColorHex: "FFFFFF",
            shadowColorHex: "000000",
            shadowRadius: 4.0,
            shadowOpacity: 0.5,
            shadowOffsetY: 2.0,
            fontDesign: "default"
        ),
        ThemePreset(
            id: "matrix",
            name: "Matrix Terminal",
            icon: "terminal.fill",
            textColorHex: "00FF41",
            shadowColorHex: "003B00",
            shadowRadius: 8.0,
            shadowOpacity: 0.8,
            shadowOffsetY: 0.0,
            fontDesign: "monospaced"
        ),
        ThemePreset(
            id: "sunset",
            name: "Golden Sunset",
            icon: "sun.max.fill",
            textColorHex: "FFB347",
            shadowColorHex: "8B4513",
            shadowRadius: 6.0,
            shadowOpacity: 0.6,
            shadowOffsetY: 3.0,
            fontDesign: "rounded"
        ),
        ThemePreset(
            id: "ice",
            name: "Arctic Ice",
            icon: "snowflake",
            textColorHex: "A8D8EA",
            shadowColorHex: "1B2838",
            shadowRadius: 5.0,
            shadowOpacity: 0.4,
            shadowOffsetY: 1.5,
            fontDesign: "default"
        ),
        ThemePreset(
            id: "neon",
            name: "Neon Pink",
            icon: "bolt.fill",
            textColorHex: "FF6EC7",
            shadowColorHex: "4B0082",
            shadowRadius: 10.0,
            shadowOpacity: 0.9,
            shadowOffsetY: 0.0,
            fontDesign: "rounded"
        ),
        ThemePreset(
            id: "ember",
            name: "Ember Red",
            icon: "flame.fill",
            textColorHex: "FF4500",
            shadowColorHex: "2D0000",
            shadowRadius: 7.0,
            shadowOpacity: 0.7,
            shadowOffsetY: 2.0,
            fontDesign: "default"
        ),
        ThemePreset(
            id: "lavender",
            name: "Lavender Dream",
            icon: "moon.stars.fill",
            textColorHex: "C8A2C8",
            shadowColorHex: "2E1A47",
            shadowRadius: 5.0,
            shadowOpacity: 0.5,
            shadowOffsetY: 2.0,
            fontDesign: "serif"
        ),
        ThemePreset(
            id: "minimal",
            name: "Minimal Gray",
            icon: "minus.circle.fill",
            textColorHex: "AAAAAA",
            shadowColorHex: "333333",
            shadowRadius: 2.0,
            shadowOpacity: 0.3,
            shadowOffsetY: 1.0,
            fontDesign: "default"
        )
    ]
}
