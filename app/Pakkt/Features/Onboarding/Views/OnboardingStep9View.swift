import SwiftUI

// MARK: - Step 9: The Personal Question
struct OnboardingStep9View: View {
    @State private var showContent = false
    @State private var goalText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    let onContinue: (String) -> Void
    
    let suggestions = [
        "Gym (always skip)",
        "Study (procrastinate)",
        "Wake up (snooze)",
        "No drinking (weekends fail)"
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Text("LET'S GET REAL")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("What's the ONE goal\nyou keep failing at?")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 40)
                
                // Input card
                VStack(spacing: 24) {
                    // Text input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MY GOAL")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.0)
                        
                        TextField("e.g., Go to gym 5x/week", text: $goalText)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.secondary.opacity(0.1))
                            )
                            .focused($isTextFieldFocused)
                    }
                    .padding(.horizontal, 32)
                    
                    Divider()
                        .padding(.horizontal, 32)
                    
                    // Suggestions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("COMMON GOALS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.0)
                            .padding(.horizontal, 32)
                        
                        VStack(spacing: 8) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button(action: {
                                    goalText = suggestion.components(separatedBy: " (")[0]
                                    isTextFieldFocused = false
                                }) {
                                    HStack {
                                        Text(suggestion)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.secondary.opacity(0.05))
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.vertical, 32)
                .frame(maxWidth: 360)
                .glassEffect(in: .rect(cornerRadius: 28))
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    if !goalText.isEmpty {
                        onContinue(goalText)
                    }
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
                .opacity(goalText.isEmpty ? 0.5 : 1.0)
                .disabled(goalText.isEmpty)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            
            // Auto-focus text field after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isTextFieldFocused = true
            }
        }
    }
}

#Preview {
    OnboardingStep9View(onContinue: { _ in })
}
