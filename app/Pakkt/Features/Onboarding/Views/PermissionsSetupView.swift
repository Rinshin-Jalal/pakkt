import SwiftUI
import UserNotifications

// MARK: - Step 25: Permissions Setup (Commit)
struct PermissionsSetupView: View {
    let onContinue: () -> Void
    @State private var notificationsEnabled = false
    @State private var screenTimeEnabled = false
    @State private var showWarning = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("YOUR PACK NEEDS TO")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("REACH YOU")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
                // Permission 1: Notifications
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                        
                        Text("NOTIFICATIONS")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(1.0)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("When your pack votes, jails you, or trash talks you.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Spacer()
                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                
                // Permission 2: Screen Time
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "hourglass.badge.plus")
                            .font(.system(size: 32))
                            .foregroundColor(.orange)
                        
                        Text("SCREEN TIME")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(1.0)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("For phone jail consequences. We can actually lock your apps.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Spacer()
                        Toggle("", isOn: $screenTimeEnabled)
                            .labelsHidden()
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                
                // Warning
                if showWarning {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        
                        Text("Without these, your pack can't enforce consequences.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.orange.opacity(0.1))
                    )
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    if !notificationsEnabled || !screenTimeEnabled {
                        showWarning = true
                    }
                    requestPermissions()
                }) {
                    HStack(spacing: 8) {
                        Text("ENABLE & CONTINUE")
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
    }
    
    private func requestPermissions() {
        // Request notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                notificationsEnabled = granted
                // After permissions, continue
                if granted {
                    onContinue()
                }
            }
        }
    }
}

#Preview {
    PermissionsSetupView(onContinue: {})
}
