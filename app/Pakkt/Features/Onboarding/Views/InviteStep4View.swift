import SwiftUI

// MARK: - Invite Step 4: Pact Preview
struct InviteStep4View: View {
    let goalName: String
    let schedule: String
    let consequence: String
    let onSign: () -> Void
    
    @State private var showContent = false
    @State private var showParchment = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                Text("YOUR PACT")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(2.0)
                    .opacity(showContent ? 1 : 0)
                
                // Pact parchment
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("THE PACT")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                        .background(Color.primary.opacity(0.2))
                    
                    // Terms
                    VStack(alignment: .leading, spacing: 16) {
                        PactRow(
                            label: "GOAL",
                            value: goalName,
                            icon: "target"
                        )
                        
                        PactRow(
                            label: "TIME",
                            value: schedule,
                            icon: "clock.fill"
                        )
                        
                        PactRow(
                            label: "CONSEQUENCE",
                            value: consequence,
                            icon: "exclamationmark.triangle.fill",
                            valueColor: .red
                        )
                    }
                    
                    Divider()
                        .background(Color.primary.opacity(0.2))
                        .padding(.top, 8)
                    
                    // Footer
                    Text("By signing, you commit to uphold this Pact with your pack")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 32)
                .opacity(showParchment ? 1 : 0)
                .scaleEffect(showParchment ? 1 : 0.9)
                .rotation3DEffect(
                    .degrees(showParchment ? 0 : 10),
                    axis: (x: 1, y: 0, z: 0)
                )
                
                Spacer()
                
                // CTA Button
                Button(action: onSign) {
                    HStack(spacing: 12) {
                        Image(systemName: "signature")
                            .font(.system(size: 18, weight: .semibold))
                        Text("SIGN TO JOIN")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
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
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showParchment = true
            }
        }
    }
}

// MARK: - Supporting Views
private struct PactRow: View {
    let label: String
    let value: String
    let icon: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(1.5)
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(valueColor)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep4View(
        goalName: "Hit the gym",
        schedule: "Every weekday at 6 AM",
        consequence: "1hr Phone Jail",
        onSign: {}
    )
}
