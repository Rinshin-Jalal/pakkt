import SwiftUI

// MARK: - Invite Step 7: Value Reveal
struct InviteStep7View: View {
    let onActivate: () -> Void
    
    @State private var showContent = false
    @State private var showFeatures = false
    
    private let features = [
        ValueFeature(
            icon: "lock.shield.fill",
            title: "Phone Jail to protect focus",
            color: .red
        ),
        ValueFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Pack streak analytics",
            color: .blue
        ),
        ValueFeature(
            icon: "location.fill",
            title: "Real-time progress tracking",
            color: .green
        ),
        ValueFeature(
            icon: "person.3.fill",
            title: "Group accountability fines",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("YOUR PACT UNLOCKS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("Premium Features")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                }
                .opacity(showContent ? 1 : 0)
                
                // Feature list
                VStack(spacing: 16) {
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        FeatureRow(feature: feature)
                            .opacity(showFeatures ? 1 : 0)
                            .offset(y: showFeatures ? 0 : 20)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                value: showFeatures
                            )
                    }
                }
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onActivate) {
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("ACTIVATE PAKKT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
                .buttonStyle(.glass)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                showFeatures = true
            }
        }
    }
}

// MARK: - Supporting Views
private struct ValueFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
}

private struct FeatureRow: View {
    let feature: ValueFeature
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                
                Image(systemName: feature.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(feature.color)
            }
            
            // Text
            Text(feature.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Checkmark
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.green)
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep7View(onActivate: {})
}
