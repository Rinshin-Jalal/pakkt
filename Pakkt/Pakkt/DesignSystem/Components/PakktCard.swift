import SwiftUI

enum PakktCardStyle {
    case glass
    case brutal
    case hybrid
    case feed
    case pack
    case alert
}

struct PakktCard<Content: View>: View {
    let style: PakktCardStyle
    let shadowColor: Color
    let content: Content

    init(
        style: PakktCardStyle = .glass,
        shadowColor: Color = PakktColors.yellow,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.shadowColor = shadowColor
        self.content = content()
    }

    var body: some View {
        Group {
            switch style {
            case .glass:
                glassCard
            case .brutal:
                brutalCard
            case .hybrid:
                hybridCard
            case .feed:
                feedCard
            case .pack:
                packCard
            case .alert:
                alertCard
            }
        }
    }

    private var glassCard: some View {
        content
            .paddingM()
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(PakktColors.glassWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                            .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
                    )
            )
            .background(.ultraThinMaterial)
    }

    private var brutalCard: some View {
        content
            .paddingM()
            .background(PakktColors.pureBlack)
            .cornerRadiusMedium()
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .stroke(PakktColors.white, lineWidth: PakktSpacing.borderBrutal)
            )
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(shadowColor)
                    .offset(x: PakktSpacing.brutalOffset, y: PakktSpacing.brutalOffset)
            )
    }

    private var hybridCard: some View {
        content
            .paddingM()
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(PakktColors.glassWhite)
            )
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .stroke(PakktColors.white, lineWidth: PakktSpacing.borderMedium)
            )
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                    .fill(shadowColor.opacity(0.5))
                    .offset(x: PakktSpacing.brutalOffset, y: PakktSpacing.brutalOffset)
            )
    }

    private var feedCard: some View {
        content
            .paddingM()
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .fill(PakktColors.glassWhite)
            )
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
            )
    }

    private var packCard: some View {
        content
            .paddingM()
            .background(PakktColors.pureBlack)
            .cornerRadiusLarge()
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .stroke(PakktColors.white, lineWidth: PakktSpacing.borderMedium)
            )
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusLarge)
                    .fill(shadowColor)
                    .offset(x: PakktSpacing.brutalOffsetLarge, y: PakktSpacing.brutalOffsetLarge)
            )
    }

    private var alertCard: some View {
        content
            .paddingM()
            .background(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusSmall)
                    .fill(PakktColors.glassWhite)
            )
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: PakktSpacing.radiusSmall)
                    .stroke(shadowColor, lineWidth: PakktSpacing.borderMedium)
            )
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: PakktSpacing.l) {
            PakktCard(style: .glass) {
                VStack(alignment: .leading) {
                    Text("Glass Card")
                        .h4Style()
                    Text("Liquid glass morphism effect")
                        .bodySmallStyle()
                }
            }

            PakktCard(style: .brutal, shadowColor: PakktColors.yellow) {
                VStack(alignment: .leading) {
                    Text("Brutal Card")
                        .h4Style()
                    Text("Bold neobrutalism 3D effect")
                        .bodySmallStyle()
                }
            }

            PakktCard(style: .hybrid, shadowColor: PakktColors.purple) {
                VStack(alignment: .leading) {
                    Text("Hybrid Card")
                        .h4Style()
                    Text("Glass + brutal combined")
                        .bodySmallStyle()
                }
            }

            PakktCard(style: .feed) {
                VStack(alignment: .leading, spacing: PakktSpacing.s) {
                    Text("Feed Card")
                        .h5Style()
                    Text("Optimized for feed posts with rounded corners")
                        .bodySmallStyle()
                }
            }

            PakktCard(style: .pack, shadowColor: PakktColors.green) {
                VStack(alignment: .leading, spacing: PakktSpacing.s) {
                    Text("Pack Card")
                        .h5Style()
                    Text("Large brutal card for packs")
                        .bodySmallStyle()
                }
            }

            PakktCard(style: .alert, shadowColor: PakktColors.red) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(PakktColors.red)
                    Text("Alert Card")
                        .bodyBoldStyle()
                }
            }
        }
        .paddingM()
    }
    .background(PakktColors.background)
}
