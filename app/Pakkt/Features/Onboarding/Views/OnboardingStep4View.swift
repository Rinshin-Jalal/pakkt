import SwiftUI

// MARK: - Step 4: The Pakkt Promise
struct OnboardingStep4View: View {
    @State private var showContent = false
    @State private var highFiveAnimation = false
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Icon group - celebrating
                HStack(spacing: -12) {
                    ForEach(0..<3) { index in
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 64, height: 64)
                            
                            Image(systemName: ["figure.run", "figure.strengthtraining.traditional", "figure.yoga"][index])
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .scaleEffect(highFiveAnimation ? 1.1 : 1.0)
                        .offset(y: highFiveAnimation ? -8 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.1), value: highFiveAnimation)
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 32)
                
                // Main promise card
                VStack(spacing: 24) {
                    // Logo or brand
                    Text("PAKKT")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.primary)
                        .tracking(4.0)
                    
                    // Value proposition
                    VStack(spacing: 12) {
                        Text("Your crew holds you accountable.")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Real consequences.\nReal results.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 32)
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    // Three key points
                    VStack(spacing: 16) {
                        PromisePoint(
                            icon: "person.3.fill",
                            text: "Your boys watch",
                            color: Color(hex: "#00D448")
                        )
                        
                        PromisePoint(
                            icon: "lock.fill",
                            text: "1hr phone jail if you miss",
                            color: Color(hex: "#FF3B30")
                        )
                        
                        PromisePoint(
                            icon: "checkmark.circle.fill",
                            text: "Actually show up",
                            color: Color(hex: "#0066FF")
                        )
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.vertical, 40)
                .frame(maxWidth: 360)
                .glassEffect(in: .rect(cornerRadius: 28))
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer()
                
                // Call to action
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("I'M IN")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                        
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
            
            // Trigger celebration animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    highFiveAnimation = true
                }
            }
        }
    }
}

// MARK: - Promise Point
struct PromisePoint: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 28)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingStep4View(onContinue: {})
}
