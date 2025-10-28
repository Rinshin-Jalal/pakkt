import SwiftUI
import Combine

struct JailSystemView: View {
    let jailEndTime: Date
    let reason: String
    let lockedApps: [String]
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Jail Icon
                Image(systemName: "lock.fill")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.red)
                    .padding(.bottom, 8)
                
                // Title
                Text("JAILED")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.primary)
                
                // Timer Display
                HStack(spacing: 12) {
                    TimeUnit(value: hours, label: "HRS")
                    Text(":")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    TimeUnit(value: minutes, label: "MIN")
                    Text(":")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    TimeUnit(value: seconds, label: "SEC")
                }
                .padding(.vertical, 32)
                
                // Reason Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                        Text("REASON")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    Text(reason)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .glassEffect(in: .rect(cornerRadius: 20))
                .padding(.horizontal, 24)
                
                // Locked Apps
                if !lockedApps.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "app.badge.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.orange)
                            Text("LOCKED APPS")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(lockedApps, id: \.self) { app in
                                VStack(spacing: 8) {
                                    Image(systemName: appIcon(for: app))
                                        .font(.system(size: 32))
                                        .foregroundColor(.secondary)
                                    Text(app)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(height: 70)
                            }
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 20))
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Info Text
                Text("You cannot use locked apps until your jail time is over")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .interactiveDismissDisabled()
    }
    
    private func appIcon(for appName: String) -> String {
        switch appName.lowercased() {
        case "instagram": return "camera.fill"
        case "tiktok": return "music.note"
        case "twitter", "x": return "bird.fill"
        case "facebook": return "person.3.fill"
        case "snapchat": return "bolt.fill"
        case "youtube": return "play.rectangle.fill"
        case "reddit": return "bubble.left.and.bubble.right.fill"
        case "discord": return "message.fill"
        default: return "app.fill"
        }
    }
}

struct TimeUnit: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.red)
                .monospacedDigit()
            
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .frame(width: 80)
    }
}

#Preview {
    JailSystemView(
        jailEndTime: Date().addingTimeInterval(3665),
        reason: "Failed gym check-in",
        lockedApps: ["Instagram", "TikTok", "Twitter", "YouTube"]
    )
}
