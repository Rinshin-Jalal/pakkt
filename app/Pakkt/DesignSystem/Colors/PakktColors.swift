import SwiftUI

struct PakktColors {
    // MARK: - Base Colors
    static let pureBlack = Color(hex: "#000000")
    static let white = Color(hex: "#FFFFFF")
    static let red = Color(hex: "#FF0000")
    static let yellow = Color(hex: "#FFFF00")
    static let green = Color(hex: "#00FF00")
    static let purple = Color(hex: "#800080")
    static let orange = Color(hex: "#FFA500")

    // MARK: - Vibrant Colors (Energy & Emotion)
    // Primary Actions - Warm & Energetic
    static let vibrantOrange = Color(hex: "#FF6B00")
    static let vibrantAmber = Color(hex: "#FFC107")

    // Achievements - Cool & Premium
    static let vibrantBlue = Color(hex: "#0066FF")
    static let vibrantPurple = Color(hex: "#8B5CF6")

    // Warnings - Urgent & Attention
    static let vibrantRed = Color(hex: "#FF3B30")

    // Success - Positive Reinforcement
    static let vibrantGreen = Color(hex: "#00D448")

    // MARK: - Glass Effect Colors
    static let glassWhite = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
    static let glassHighlight = Color.white.opacity(0.05)

    // MARK: - Semantic Colors
    static let background = pureBlack
    static let surface = Color.white.opacity(0.05)
    static let surfaceElevated = Color.white.opacity(0.1)

    static let primaryText = white
    static let secondaryText = Color.white.opacity(0.7)
    static let tertiaryText = Color.white.opacity(0.5)

    static let success = vibrantGreen
    static let warning = vibrantAmber
    static let error = vibrantRed
    static let info = vibrantPurple

    static let accent = vibrantOrange // Primary brand accent
    static let accentSecondary = vibrantAmber

    // MARK: - Gradients (Vibrant & Energetic)
    static let primaryGradient = LinearGradient(
        colors: [vibrantOrange, vibrantAmber],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let achievementGradient = LinearGradient(
        colors: [vibrantBlue, vibrantPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let glassGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        colors: [green, green.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let errorGradient = LinearGradient(
        colors: [red, red.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color Extension for Hex Support
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
