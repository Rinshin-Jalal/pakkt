import SwiftUI

struct PakktTypography {
    // MARK: - Font Sizes
    static let h1 = Font.system(size: 48, weight: .black, design: .default)
    static let h2 = Font.system(size: 36, weight: .black, design: .default)
    static let h3 = Font.system(size: 28, weight: .bold, design: .default)
    static let h4 = Font.system(size: 24, weight: .bold, design: .default)
    static let h5 = Font.system(size: 20, weight: .semibold, design: .default)
    static let h6 = Font.system(size: 18, weight: .semibold, design: .default)

    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyBold = Font.system(size: 16, weight: .bold, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmallBold = Font.system(size: 14, weight: .bold, design: .default)

    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let captionBold = Font.system(size: 12, weight: .bold, design: .default)

    static let button = Font.system(size: 16, weight: .bold, design: .default)
    static let buttonSmall = Font.system(size: 14, weight: .bold, design: .default)
    static let buttonLarge = Font.system(size: 18, weight: .bold, design: .default)
}

// MARK: - Typography View Modifiers
extension View {
    func h1Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h1)
            .foregroundColor(color)
    }

    func h2Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h2)
            .foregroundColor(color)
    }

    func h3Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h3)
            .foregroundColor(color)
    }

    func h4Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h4)
            .foregroundColor(color)
    }

    func h5Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h5)
            .foregroundColor(color)
    }

    func h6Style(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.h6)
            .foregroundColor(color)
    }

    func bodyStyle(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.body)
            .foregroundColor(color)
    }

    func bodyBoldStyle(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.bodyBold)
            .foregroundColor(color)
    }

    func bodySmallStyle(color: Color = PakktColors.secondaryText) -> some View {
        self
            .font(PakktTypography.bodySmall)
            .foregroundColor(color)
    }

    func bodySmallBoldStyle(color: Color = PakktColors.secondaryText) -> some View {
        self
            .font(PakktTypography.bodySmallBold)
            .foregroundColor(color)
    }

    func captionStyle(color: Color = PakktColors.tertiaryText) -> some View {
        self
            .font(PakktTypography.caption)
            .foregroundColor(color)
    }

    func captionBoldStyle(color: Color = PakktColors.tertiaryText) -> some View {
        self
            .font(PakktTypography.captionBold)
            .foregroundColor(color)
    }

    func buttonStyle(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.button)
            .foregroundColor(color)
    }

    func buttonSmallStyle(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.buttonSmall)
            .foregroundColor(color)
    }

    func buttonLargeStyle(color: Color = PakktColors.primaryText) -> some View {
        self
            .font(PakktTypography.buttonLarge)
            .foregroundColor(color)
    }
}
