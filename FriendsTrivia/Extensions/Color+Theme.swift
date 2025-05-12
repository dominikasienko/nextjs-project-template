import SwiftUI

extension Color {
    static let theme = ThemeColors()
}

struct ThemeColors {
    // Main colors from Friends A to Z Guide
    let primaryBlue = Color(hex: "#00B2C8")  // Turquoise blue from the deck
    let secondaryYellow = Color(hex: "#FFD700")  // Yellow accent from the deck
    let cardBackground = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#666666")
    
    // Additional UI colors
    let background = Color(hex: "#F5F5F5")
    let success = Color(hex: "#4CAF50")
    let error = Color(hex: "#F44336")
    let shadow = Color.black.opacity(0.1)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
