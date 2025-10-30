import SwiftUI

// MARK: - Step 24: Countdown To First Challenge (Urgency)
struct CountdownToFirstChallengeView: View {
    let onContinue: () -> Void
    @Binding var firstCheckInTime: Date
    @State private var timeRemaining: String = ""
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("YOUR FIRST CHECK-IN")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("STARTS IN...")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .multilineTextAlignment(.center)
                
                // Countdown
                VStack(spacing: 16) {
                    Text(timeRemaining)
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.primary)
                        .monospacedDigit()
                    
                    Text("HOURS")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                }
                
                // Details Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                        Text(firstCheckInTime, style: .date)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("at")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(firstCheckInTime, style: .time)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your pack expects you to check in.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Miss it?")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "eye.fill")
                                    .foregroundColor(.orange)
                                Text("They'll know.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "hand.raised.fill")
                                    .foregroundColor(.orange)
                                Text("They'll vote.")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.orange)
                                Text("You'll pay.")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                
                // Emphasis
                VStack(spacing: 8) {
                    Text("This is real.")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("No backing out now.")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("I'M READY")
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
            updateTimeRemaining()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                updateTimeRemaining()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func updateTimeRemaining() {
        let interval = firstCheckInTime.timeIntervalSinceNow
        let hours = Int(interval / 3600)
        timeRemaining = String(format: "%02d", max(0, hours))
    }
}

#Preview {
    CountdownToFirstChallengeView(
        onContinue: {},
        firstCheckInTime: .constant(Calendar.current.date(byAdding: .hour, value: 8, to: Date()) ?? Date())
    )
}
