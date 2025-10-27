import SwiftUI

// MARK: - Step 10: The Emotional Impact
struct OnboardingStep10View: View {
    @State private var showContent = false
    @State private var failureImpact: Double = 5.0
    @State private var successImpact: Double = 8.0
    let goal: String
    let onContinue: (Double, Double) -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Text("HOW DOES IT FEEL?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("When you fail vs succeed")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 32)
                
                // Impact card
                VStack(spacing: 24) {
                    // Failure section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.red)
                            
                            Text("WHEN I FAIL")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text(getFailureEmotion())
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        // Slider
                        VStack(spacing: 12) {
                            Slider(value: $failureImpact, in: 1...10, step: 1)
                                .tint(.red.opacity(0.8))
                            
                            HStack {
                                Text("Not Bad")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(String(format: "%.0f", failureImpact))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.red)
                                    .monospacedDigit()
                                
                                Spacer()
                                
                                Text("Devastating")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.red.opacity(0.06))
                    )
                    
                    // Success section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.green)
                            
                            Text("WHEN I SUCCEED")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        Text(getSuccessEmotion())
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        // Slider
                        VStack(spacing: 12) {
                            Slider(value: $successImpact, in: 1...10, step: 1)
                                .tint(.green.opacity(0.8))
                            
                            HStack {
                                Text("Okay")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(String(format: "%.0f", successImpact))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                                    .monospacedDigit()
                                
                                Spacer()
                                
                                Text("Amazing")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.green.opacity(0.06))
                    )
                }
                .padding(24)
                .frame(maxWidth: 360)
                .glassEffect(in: .rect(cornerRadius: 28))
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    onContinue(failureImpact, successImpact)
                }) {
                    HStack(spacing: 8) {
                        Text("CONTINUE")
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
    }
    
    private func getFailureEmotion() -> String {
        switch Int(failureImpact) {
        case 1...3: return "I feel okay, not a big deal"
        case 4...6: return "I feel disappointed and guilty"
        case 7...8: return "I feel weak and ashamed"
        default: return "I feel like a complete failure"
        }
    }
    
    private func getSuccessEmotion() -> String {
        switch Int(successImpact) {
        case 1...3: return "I feel slightly better"
        case 4...6: return "I feel proud and motivated"
        case 7...8: return "I feel strong and accomplished"
        default: return "I feel unstoppable and amazing"
        }
    }
}

#Preview {
    OnboardingStep10View(goal: "Go to gym", onContinue: { _, _ in })
}
