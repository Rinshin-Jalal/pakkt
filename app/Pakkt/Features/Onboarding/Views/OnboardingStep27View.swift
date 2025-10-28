import SwiftUI

struct OnboardingStep27View: View {
    let onContinue: () -> Void
    
    @State private var hasGranted: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Image(systemName: "hourglass")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)
                
                Text("SCREEN TIME ACCESS")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Phone jail requires Screen Time access.\nGrant your pack this power?")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
            
            // Permission Info
            VStack(alignment: .leading, spacing: 16) {
                PermissionRow(
                    icon: "lock.shield",
                    title: "Lock apps",
                    description: "Restrict access when jailed"
                )
                
                PermissionRow(
                    icon: "chart.bar",
                    title: "Monitor usage",
                    description: "Track accountability"
                )
                
                PermissionRow(
                    icon: "bell.badge",
                    title: "Enforce limits",
                    description: "Real consequences"
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 12) {
                Button(action: {
                    // TODO: Request Screen Time permission
                    hasGranted = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onContinue()
                    }
                }) {
                    Text("GRANT ACCESS")
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

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingStep27View(onContinue: {})
}
