import SwiftUI
import Combine

struct ActiveCheckInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var timeRemaining: TimeInterval = 1800 // 30 minutes in seconds
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?
    @State private var showCheckInSheet = false
    
    // Mock data - replace with actual goal data
    let goalTitle: String = "🏋️ Gym Session"
    let goalTime: String = "7:00 AM"
    let windowStart: String = "6:30 AM"
    let currentTime: String = "6:42 AM"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Timer Display
                    VStack(spacing: 16) {
                        Text("TIME REMAINING")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                        
                        Text(timeString)
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(timeRemaining < 300 ? .red : .primary)
                            .monospacedDigit()
                        
                        Text("TO CHECK IN")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Goal Info Card
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(goalTitle)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 20) {
                                InfoRow(icon: "clock.fill", label: "Due", value: goalTime)
                                InfoRow(icon: "door.left.hand.open", label: "Window", value: windowStart)
                            }
                        }
                        
                        Divider()
                            .background(Color.secondary.opacity(0.3))
                        
                        // Status
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            
                            Text("Window is open")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("Check in anytime")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(24)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Check In Button
                    Button(action: {
                        showCheckInSheet = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text("Check In Now")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Active Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
        .sheet(isPresented: $showCheckInSheet) {
            CreateCheckInView()
        }
    }
    
    private var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = timer
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    stopTimer()
                }
            }
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    ActiveCheckInView()
}
