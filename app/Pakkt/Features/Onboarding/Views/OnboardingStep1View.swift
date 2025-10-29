import SwiftUI

// MARK: - Step 1: The Relatable Failure
struct OnboardingStep1View: View {
    @State private var showNotifications = false
    @State private var pulseAnimation = false
    @State private var showInviteCodeInput = false
    @State private var showInviteButton = false
    @State private var inviteCode = ""
    let onContinue: () -> Void
    let onInviteCode: ((String) -> Void)?
    
    init(onContinue: @escaping () -> Void, onInviteCode: ((String) -> Void)? = nil) {
        self.onContinue = onContinue
        self.onInviteCode = onInviteCode
    }
    
    var body: some View {
        ZStack {
            // Background with native dark mode support
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Invite Code Button at top
                if let onInviteCode = onInviteCode {
                    HStack {
                        Spacer()
                        Button(action: {
                            showInviteCodeInput = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "envelope.badge.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Have an invite code?")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.1))
                            )
                        }
                        .opacity(showInviteButton ? 1 : 0)
                        .scaleEffect(showInviteButton ? 1 : 0.8)
                        .offset(y: showInviteButton ? 0 : -20)
                        Spacer()
                    }
                    .padding(.top, 20)
                } else {
                    Spacer().frame(height: 20)
                }
                
                // Icon
                Image(systemName: "figure.walk")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundColor(.secondary)
                    .opacity(showNotifications ? 1 : 0)
                    .scaleEffect(showNotifications ? 1 : 0.8)
                    .padding(.top, onInviteCode != nil ? 0 : 40)
                
                // Header with gradient effect
                VStack(spacing: 8) {
                    Text("MISSED GYM AGAIN")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("You skipped gym again. 3rd time this week.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(showNotifications ? 1 : 0)
                
                // Phone mockup with missed notifications
                VStack(spacing: 0) {
                    // Phone notch/top
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 100, height: 4)
                        .padding(.top, 12)
                    
                    // Status bar
                    HStack {
                        Text("9:41")
                            .font(.system(size: 13, weight: .semibold))
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "cellularbars")
                                .font(.system(size: 12))
                            Image(systemName: "wifi")
                                .font(.system(size: 12))
                            Image(systemName: "battery.100")
                                .font(.system(size: 14))
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    
                    // Notifications list
                    VStack(spacing: 10) {
                        MissedNotificationCard(
                            time: "7:00 AM",
                            title: "Gym App",
                            message: "Missed check-in",
                            delay: 0.1
                        )
                        
                        MissedNotificationCard(
                            time: "7:15 AM",
                            title: "Gym App",
                            message: "15 min late",
                            delay: 0.3
                        )
                        
                        MissedNotificationCard(
                            time: "7:30 AM",
                            title: "Gym App",
                            message: "Window closed",
                            delay: 0.5
                        )
                        
                        MissedNotificationCard(
                            time: "8:00 AM",
                            title: "Gym App",
                            message: "You missed it",
                            delay: 0.7
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // Divider
                    Divider()
                        .padding(.horizontal, 16)
                    
                    // Summary stats
                    VStack(spacing: 12) {
                        StatRow(icon: "xmark.circle", text: "3 missed check-ins", color: .secondary)
                        
                        // Final punch line
                        HStack(spacing: 8) {
                            Image(systemName: "eye.slash")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Nobody even noticed")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                }
                .glassEffect(in: .rect(cornerRadius: 20))
                .padding(.horizontal, 20)
                
                
                // Continue button with glass effect
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("TAP TO CONTINUE")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.0)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showNotifications = true
            }
            
            // Pulse animation for subtle attention
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
            
            // Show invite button with delay
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(2.5)) {
                showInviteButton = true
            }
        }
        .alert("Enter Invite Code", isPresented: $showInviteCodeInput) {
            TextField("Invite Code", text: $inviteCode)
                .textInputAutocapitalization(.characters)
            Button("Cancel", role: .cancel) {
                inviteCode = ""
            }
            Button("Join Pack") {
                if !inviteCode.isEmpty, let onInviteCode = onInviteCode {
                    onInviteCode(inviteCode.uppercased())
                }
            }
        } message: {
            Text("Enter the invite code you received from your pack")
        }
    }
}

// MARK: - Stat Row Component
struct StatRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Missed Notification Card
struct MissedNotificationCard: View {
    let time: String
    let title: String
    let message: String
    let delay: Double
    
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 12) {
            // App icon mockup
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.2))
                
                Image(systemName: "figure.run")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(width: 32, height: 32)
            
            // Content
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(time)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondary.opacity(0.05))
        )
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -30)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    OnboardingStep1View(onContinue: {}, onInviteCode: { code in
        print("Invite code: \(code)")
    })
}
