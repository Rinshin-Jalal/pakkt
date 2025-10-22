import SwiftUI

struct PakktSpacing {
    // MARK: - 8pt Grid System
    static let xxs: CGFloat = 4    // 0.5x
    static let xs: CGFloat = 8     // 1x
    static let s: CGFloat = 12     // 1.5x
    static let m: CGFloat = 16     // 2x
    static let l: CGFloat = 24     // 3x
    static let xl: CGFloat = 32    // 4x
    static let xxl: CGFloat = 40   // 5x
    static let xxxl: CGFloat = 48  // 6x

    // MARK: - Corner Radius
    static let radiusSmall: CGFloat = 8
    static let radiusMedium: CGFloat = 12
    static let radiusLarge: CGFloat = 16
    static let radiusXLarge: CGFloat = 24

    // MARK: - Border Width
    static let borderThin: CGFloat = 1
    static let borderMedium: CGFloat = 2
    static let borderThick: CGFloat = 3
    static let borderBrutal: CGFloat = 4

    // MARK: - Shadow Offset (for brutal 3D effect)
    static let brutalOffset: CGFloat = 4
    static let brutalOffsetLarge: CGFloat = 6
}

// MARK: - Spacing View Modifiers
extension View {
    // Padding Modifiers
    func paddingXXS() -> some View {
        self.padding(PakktSpacing.xxs)
    }

    func paddingXS() -> some View {
        self.padding(PakktSpacing.xs)
    }

    func paddingS() -> some View {
        self.padding(PakktSpacing.s)
    }

    func paddingM() -> some View {
        self.padding(PakktSpacing.m)
    }

    func paddingL() -> some View {
        self.padding(PakktSpacing.l)
    }

    func paddingXL() -> some View {
        self.padding(PakktSpacing.xl)
    }

    func paddingXXL() -> some View {
        self.padding(PakktSpacing.xxl)
    }

    func paddingXXXL() -> some View {
        self.padding(PakktSpacing.xxxl)
    }

    // Corner Radius Modifiers
    func cornerRadiusSmall() -> some View {
        self.cornerRadius(PakktSpacing.radiusSmall)
    }

    func cornerRadiusMedium() -> some View {
        self.cornerRadius(PakktSpacing.radiusMedium)
    }

    func cornerRadiusLarge() -> some View {
        self.cornerRadius(PakktSpacing.radiusLarge)
    }

    func cornerRadiusXLarge() -> some View {
        self.cornerRadius(PakktSpacing.radiusXLarge)
    }

    // Brutal 3D Shadow Effect
    func brutalShadow(color: Color = PakktColors.yellow) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .stroke(PakktColors.pureBlack, lineWidth: PakktSpacing.borderBrutal)
            )
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(color)
                    .offset(x: PakktSpacing.brutalOffset, y: PakktSpacing.brutalOffset)
            )
    }

    func brutalShadowLarge(color: Color = PakktColors.yellow) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .stroke(PakktColors.pureBlack, lineWidth: PakktSpacing.borderBrutal)
            )
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .fill(color)
                    .offset(x: PakktSpacing.brutalOffsetLarge, y: PakktSpacing.brutalOffsetLarge)
            )
    }

    // Glass Effect
    func glassEffect() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(PakktColors.glassWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                            .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            )
            .background(.ultraThinMaterial)
    }
}
