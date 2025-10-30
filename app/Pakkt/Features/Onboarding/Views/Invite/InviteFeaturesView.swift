import SwiftUI

// MARK: - Invite Step 2: Preview of What's Inside
struct InviteStep2View: View {
    let onContinue: () -> Void
    
    @State private var currentIndex = 0
    @State private var showContent = false
    
    private let features = [
        Feature(
            icon: "chart.line.uptrend.xyaxis",
            title: "AI Tracks Streaks",
            subtitle: "Never lose momentum"
        ),
        Feature(
            icon: "lock.fill",
            title: "Phone Jail",
            subtitle: "Enforces discipline"
        ),
        Feature(
            icon: "bubble.left.and.bubble.right.fill",
            title: "Pack Support",
            subtitle: "Your team cheers you on"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("PAKKT TURNS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("DISCIPLINE INTO A TEAM SPORT")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(showContent ? 1 : 0)
                
                // Carousel
                TabView(selection: $currentIndex) {
                    ForEach(features.indices, id: \.self) { index in
                        FeatureCard(feature: features[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 280)
                .opacity(showContent ? 1 : 0)
                
                // Custom page indicators
                HStack(spacing: 8) {
                    ForEach(features.indices, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentIndex == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
                .padding(.top, 8)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onContinue) {
                    HStack(spacing: 12) {
                        Text("CONTINUE")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

// MARK: - Supporting Views
private struct Feature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

private struct FeatureCard: View {
    let feature: Feature
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: feature.icon)
                .font(.system(size: 64, weight: .regular))
                .foregroundColor(.blue)
                .frame(height: 80)
            
            // Text
            VStack(spacing: 8) {
                Text(feature.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(1.0)
                
                Text(feature.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .glassEffect(in: .rect(cornerRadius: 30))
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview
#Preview {
    InviteStep2View(onContinue: {})
}
