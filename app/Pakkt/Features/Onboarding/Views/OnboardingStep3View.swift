import SwiftUI
import Combine

// MARK: - Step 3: Phone Jail Demo
struct OnboardingStep3View: View {
    @State private var showContent = false
    @State private var currentTime = Date()
    let onContinue: () -> Void
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let jailEndTime = Date().addingTimeInterval(3540) // 59 minutes
    
    private var timeRemaining: TimeInterval {
        max(0, jailEndTime.timeIntervalSince(currentTime))
    }
    
    private var hours: Int {
        Int(timeRemaining) / 3600
    }
    
    private var minutes: Int {
        (Int(timeRemaining) % 3600) / 60
    }
    
    private var seconds: Int {
        Int(timeRemaining) % 60
    }
    
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
                
                // Phone jail screen - using JailSystemView design
                VStack(spacing: 24) {
                    // Jail Icon
                    Image(systemName: "lock.fill")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.top, 24)
                    
                    // Title
                    Text("JAILED")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.primary)
                    
                    // Timer Display
                    HStack(spacing: 8) {
                        TimeUnit(value: hours, label: "HRS")
                        Text(":")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        TimeUnit(value: minutes, label: "MIN")
                        Text(":")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        TimeUnit(value: seconds, label: "SEC")
                    }
                    .padding(.vertical, 20)
                    
                    // Reason Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                            Text("REASON")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        Text("Missed Gym Pack")
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("7:00 AM check-in")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.secondary.opacity(0.08))
                    )
                    .padding(.horizontal, 20)
                    
                    // Locked Apps
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "app.badge.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                            Text("LOCKED APPS")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            ForEach(["Instagram", "TikTok", "YouTube"], id: \.self) { app in
                                VStack(spacing: 6) {
                                    Image(systemName: appIcon(for: app))
                                        .font(.system(size: 24))
                                        .foregroundColor(.secondary)
                                    Text(app)
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity, minHeight: 60)
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.secondary.opacity(0.08))
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
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
            currentTime = Date()
        }
    }
    
    private func appIcon(for appName: String) -> String {
        switch appName.lowercased() {
        case "instagram": return "camera.fill"
        case "tiktok": return "music.note"
        case "youtube": return "play.rectangle.fill"
        default: return "app.fill"
        }
    }
}

#Preview {
    OnboardingStep3View(onContinue: {})
}
