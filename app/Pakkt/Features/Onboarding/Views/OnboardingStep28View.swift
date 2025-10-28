import SwiftUI

struct OnboardingStep28View: View {
    let onContinue: () -> Void
    
    @State private var showPreview: Bool = false
    @State private var hasGranted: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)
                
                Text("NOTIFICATIONS")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Get pack notifications.\n'Where are you?' texts hurt more.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            
            // Notification Preview
            if showPreview {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Image(systemName: "app.badge")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Pakkt")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Sarah checked in. You're 10 min late.")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("now")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .glassEffect(in: .rect(cornerRadius: 20))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Notification Types
            VStack(alignment: .leading, spacing: 16) {
                NotificationTypeRow(
                    icon: "clock",
                    title: "Check-in reminders",
                    color: .blue
                )
                
                NotificationTypeRow(
                    icon: "exclamationmark.triangle",
                    title: "Late warnings",
                    color: .orange
                )
                
                NotificationTypeRow(
                    icon: "person.2",
                    title: "Pack activity",
                    color: .purple
                )
                
                NotificationTypeRow(
                    icon: "lock",
                    title: "Jail notifications",
                    color: .red
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 12) {
                Button(action: {
                    withAnimation {
                        showPreview = true
                    }
                    
                    // TODO: Request notification permission
                    hasGranted = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onContinue()
                    }
                }) {
                    Text("ENABLE NOTIFICATIONS")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .glassEffect(in: .rect(cornerRadius: 30))
                }
                
                Button(action: onContinue) {
                    Text("Maybe Later")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

struct NotificationTypeRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingStep28View(onContinue: {})
}
