import SwiftUI
import Combine

// MARK: - Step 3: Phone Jail Demo
struct OnboardingStep3View: View {
    @State private var showContent = false
    @State private var timeRemaining: Int = 1740 // 29 minutes in seconds
    @State private var escapeAttempts: Int = 0
    let onContinue: () -> Void
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header
                VStack(spacing: 4) {
                    Text("PHONE JAIL")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("Real consequence when you miss")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 32)
                
                // Phone jail screen
                VStack(spacing: 0) {
                    // Main content
                    VStack(spacing: 28) {
                        // Timer circle - massive and dominant
                        ZStack {
                            Circle()
                                .stroke(Color.secondary.opacity(0.1), lineWidth: 8)
                                .frame(width: 220, height: 220)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(timeRemaining) / 1800.0)
                                .stroke(Color(hex: "#FF3B30"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 220, height: 220)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(Color(hex: "#FF3B30"))
                                
                                Text(formatTime(timeRemaining))
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.primary)
                                    .monospacedDigit()
                            }
                        }
                        
                        // Reason - clean and simple
                        VStack(spacing: 8) {
                            Text("Missed Gym Pack")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("7:00 AM check-in")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .padding(.horizontal, 40)
                        
                        // Blocked apps - simplified
                        VStack(spacing: 12) {
                            HStack(spacing: 20) {
                                ForEach(["Instagram", "TikTok", "Snapchat", "YouTube"], id: \.self) { app in
                                    VStack(spacing: 6) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.secondary.opacity(0.15))
                                                .frame(width: 52, height: 52)
                                            
                                            Image(systemName: "xmark")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color(hex: "#FF3B30").opacity(0.6))
                                        }
                                        
                                        Text(String(app.prefix(2)))
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.secondary.opacity(0.7))
                                    }
                                }
                            }
                        }
                        
                        // Try escape
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                escapeAttempts += 1
                            }
                        }) {
                            HStack(spacing: 8) {
                                if escapeAttempts > 0 {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 14))
                                }
                                Text(escapeAttempts == 0 ? "Try to escape" : "Locked (\(escapeAttempts)x)")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(escapeAttempts > 0 ? Color(hex: "#FF3B30") : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.vertical, 32)
                }
                .frame(maxWidth: 360)
                .glassEffect(in: .rect(cornerRadius: 28))
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer().frame(height: 24)
                
                // Bottom text
                Text("1 hour locked out. No escape.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Continue button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("I UNDERSTAND")
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
                showContent = true
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

#Preview {
    OnboardingStep3View(onContinue: {})
}
