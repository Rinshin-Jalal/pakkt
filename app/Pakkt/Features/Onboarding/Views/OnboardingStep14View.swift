import SwiftUI

struct OnboardingStep14View: View {
    @Binding var commitmentStyle: String
    let onContinue: () -> Void
    
    @State private var selectedStyle: String? = nil
    
    private let styles = [
        CommitmentStyle(
            id: "gentle",
            title: "GENTLE REMINDERS",
            description: "Friendly nudges from your pack. We'll remind you, but won't pressure you.",
            icon: "heart.fill",
            color: Color.white.opacity(0.05)
        ),
        CommitmentStyle(
            id: "tough",
            title: "TOUGH LOVE",
            description: "Your pack will call you out. Expect roasting if you miss.",
            icon: "flame.fill",
            color: Color.white.opacity(0.05)
        ),
        CommitmentStyle(
            id: "consequences",
            title: "REAL CONSEQUENCES",
            description: "Money & jail time. Your pack enforces actual stakes.",
            icon: "bolt.fill",
            color: Color.white.opacity(0.05)
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("COMMITMENT STYLE")
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.5))
                
                Text("What type of accountability\nactually works for you?")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Styles
            VStack(spacing: 16) {
                ForEach(styles) { style in
                    CommitmentStyleCard(
                        style: style,
                        isSelected: selectedStyle == style.id,
                        onTap: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedStyle = style.id
                                commitmentStyle = style.id
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                if selectedStyle != nil {
                    onContinue()
                }
            }) {
                HStack(spacing: 12) {
                    Text("CONTINUE")
                        .font(.system(size: 17, weight: .semibold))
                        .tracking(1.0)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            }
            .buttonStyle(.glass)
            .opacity(selectedStyle != nil ? 1 : 0.5)
            .disabled(selectedStyle == nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct CommitmentStyle: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct CommitmentStyleCard: View {
    let style: CommitmentStyle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: style.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .cyan : .white.opacity(0.5))
                    .frame(width: 48, height: 48)
                    .background(style.color)
                    .clipShape(Circle())
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(style.title)
                        .font(.system(size: 15, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(.white)
                    
                    Text(style.description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection Indicator
                Circle()
                    .strokeBorder(isSelected ? Color.cyan : Color.white.opacity(0.2), lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.cyan : Color.clear))
                    .frame(width: 24, height: 24)
            }
            .padding(20)
            .glassEffect(in: .rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? Color.cyan.opacity(0.5) : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OnboardingStep14View(
        commitmentStyle: .constant(""),
        onContinue: {}
    )
}
