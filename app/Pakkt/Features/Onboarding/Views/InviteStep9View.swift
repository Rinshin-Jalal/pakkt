import SwiftUI

// MARK: - Invite Step 9: Activation Success
struct InviteStep9View: View {
    let onComplete: () -> Void
    
    @State private var showContent = false
    @State private var showConfetti = false
    @State private var unlockAnimation = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Unlock animation
                ZStack {
                    // Unlocked parchment
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.green.opacity(0.1),
                                    Color.blue.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(unlockAnimation ? 1.1 : 1.0)
                    
                    // Open lock with glow
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)
                            .opacity(unlockAnimation ? 1 : 0)
                        
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(unlockAnimation ? 0 : -30))
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                // Success message
                VStack(spacing: 16) {
                    Text("PAKKT+ ACTIVE")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                        .tracking(2.0)
                    
                    Text("Your Pact Begins Now")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                    
                    Text("Welcome to your pack. Stay consistent, stay accountable.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onComplete) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .semibold))
                        Text("ENTER FEED")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                unlockAnimation = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep9View(onComplete: {})
}
