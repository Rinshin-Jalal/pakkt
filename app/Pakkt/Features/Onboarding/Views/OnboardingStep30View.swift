import SwiftUI

struct OnboardingStep30View: View {
    let onContinue: () -> Void
    @State private var timeRemaining = 3600 // 1 hour in seconds
    @State private var attemptedEscape = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Jail icon
                Image(systemName: "lock.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.red.opacity(0.9))
                    .padding(.bottom, 8)
                
                // Title
                Text("PHONE JAIL")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                // Timer
                VStack(spacing: 12) {
                    Text(timeString(from: timeRemaining))
                        .font(.system(size: 56, weight: .bold, design: .monospaced))
                        .foregroundStyle(.red)
                    
                    Text("TIME REMAINING")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(1.5)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 32)
                .glassEffect(in: .rect(cornerRadius: 20))
                .padding(.horizontal, 24)
                
                // Description
                Text("This is what happens when you skip")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Blocked apps demo
                VStack(spacing: 12) {
                    Text("BLOCKED APPS")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(1.5)
                    
                    HStack(spacing: 16) {
                        ForEach(["Instagram", "TikTok", "Twitter"], id: \.self) { app in
                            VStack(spacing: 8) {
                                Image(systemName: "app.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.secondary.opacity(0.3))
                                
                                Text(app)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 70, height: 70)
                            .glassEffect(in: .rect(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.red.opacity(0.5), lineWidth: 2)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                
                if attemptedEscape {
                    Text("Nice try. Timer pauses when you leave.")
                        .font(.system(size: 15))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .glassEffect(in: .rect(cornerRadius: 12))
                        .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
                
                // Continue button
                VStack(spacing: 12) {
                    Button(action: { attemptedEscape = true }) {
                        Text("Try to Escape")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .disabled(attemptedEscape)
                    .opacity(attemptedEscape ? 0.5 : 1)
                    
                    Button(action: onContinue) {
                        Text("I Get It - Show Me My First Check-In")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .animation(.spring(response: 0.3), value: attemptedEscape)
    }
    
    private func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
}

#Preview {
    OnboardingStep30View(onContinue: {})
}
