import SwiftUI

enum PakktButtonStyle {
    case primary
    case secondary
    case icon
    case ghost
}

struct PakktButton: View {
    let title: String
    let icon: String?
    let style: PakktButtonStyle
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        style: PakktButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: PakktSpacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(PakktTypography.button)
            }
            .foregroundColor(foregroundColor)
            .paddingM()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadiusMedium()
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .if(style == .primary) { view in
                view.brutalShadow(color: PakktColors.yellow)
            }
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return PakktColors.pureBlack
        case .secondary, .icon, .ghost:
            return PakktColors.white
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return PakktColors.yellow
        case .secondary:
            return PakktColors.glassWhite
        case .icon, .ghost:
            return Color.clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary:
            return PakktColors.pureBlack
        case .secondary:
            return PakktColors.glassBorder
        case .icon, .ghost:
            return PakktColors.white
        }
    }

    private var borderWidth: CGFloat {
        switch style {
        case .primary:
            return PakktSpacing.borderBrutal
        case .secondary, .icon, .ghost:
            return PakktSpacing.borderThin
        }
    }
}

// MARK: - Conditional View Modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: PakktSpacing.m) {
        PakktButton("Primary Button", icon: "star.fill", style: .primary) {
            print("Primary tapped")
        }

        PakktButton("Secondary Button", icon: "heart.fill", style: .secondary) {
            print("Secondary tapped")
        }

        PakktButton("Icon Button", icon: "plus", style: .icon) {
            print("Icon tapped")
        }

        PakktButton("Ghost Button", style: .ghost) {
            print("Ghost tapped")
        }
    }
    .paddingM()
    .background(PakktColors.background)
}
