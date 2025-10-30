import SwiftUI

// MARK: - Step 3: Goal Failure Input (Pain)
struct GoalFailureInputView: View {
    let onContinue: () -> Void
    @Binding var goalName: String
    @FocusState private var isFieldFocused: Bool
    
    let suggestions = [
        ("figure.run", "Gym", "always skip"),
        ("book.fill", "Study", "procrastinate"),
        ("alarm.fill", "Wake up", "hit snooze"),
        ("hand.raised.fill", "No drinking", "weekends fail")
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Text("LET'S GET REAL")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.0)
                    
                    Text("What's the ONE goal you keep failing at?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Text Input
                TextField("Enter goal name...", text: $goalName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(16)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .focused($isFieldFocused)
                    .padding(.horizontal, 24)
                
                // Suggestions
                VStack(alignment: .leading, spacing: 12) {
                    Text("SUGGESTIONS:")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(1.0)
                        .padding(.horizontal, 24)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(suggestions, id: \.1) { icon, title, subtitle in
                            Button(action: {
                                goalName = title
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: icon)
                                            .font(.system(size: 16, weight: .semibold))
                                        Text(title)
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.primary)
                                    
                                    Text("(\(subtitle))")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .glassEffect(in: .rect(cornerRadius: 30))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
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
                .disabled(goalName.isEmpty)
                .opacity(goalName.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}

#Preview {
    GoalFailureInputView(onContinue: {}, goalName: .constant(""))
}
