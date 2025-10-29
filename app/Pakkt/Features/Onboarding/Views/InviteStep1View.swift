import SwiftUI

// MARK: - Invite Step 1: The Call to Join
struct InviteStep1View: View {
    let packName: String
    let goalName: String
    let memberCount: Int
    let streakDays: Int
    let onJoin: () -> Void
    
    @State private var pulseAnimation = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Pack parchment mini-card
                VStack(spacing: 16) {
                    // Pack avatars ring
                    HStack(spacing: -12) {
                        ForEach(0..<min(memberCount, 4), id: \.self) { index in
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(Color(.systemBackground), lineWidth: 2)
                                )
                                .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: pulseAnimation
                                )
                        }
                    }
                    .padding(.top, 8)
                    
                    // Streak indicator
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.orange)
                        Text("\(streakDays)-day streak")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.15))
                    )
                }
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.9)
                
                // Copy
                VStack(spacing: 16) {
                    Text("YOU'VE BEEN INVITED")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("Join \(packName)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                    
                    Text("Your friends already signed the Pact to \(goalName)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onJoin) {
                    HStack(spacing: 12) {
                        Image(systemName: "signature")
                            .font(.system(size: 18, weight: .semibold))
                        Text("JOIN THE PACT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
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
            pulseAnimation = true
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep1View(
        packName: "Morning Warriors",
        goalName: "Hit the gym",
        memberCount: 3,
        streakDays: 7,
        onJoin: {}
    )
}
