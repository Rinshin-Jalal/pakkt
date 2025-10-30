import SwiftUI

// MARK: - Step 9: Success Vision (Pain to Relief transition)
struct SuccessVisionView: View {
    let onContinue: () -> Void
    @Binding var successVision: String
    @FocusState private var isFieldFocused: Bool
    
    let examples = [
        "More energy every day",
        "Confidence finally",
        "Respect from friends",
        "Breaking the pattern",
        "Proving yourself"
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 16) {
                        Text("Now imagine...")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("What would ACTUALLY change if you succeeded?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    
                    // Text Area
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $successVision)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(height: 140)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .padding(12)
                            .focused($isFieldFocused)
                        
                        if successVision.isEmpty {
                            Text("Describe your transformation...")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.leading, 16)
                                .padding(.top, 20)
                                .allowsHitTesting(false)
                        }
                    }
                    .glassEffect(in: .rect(cornerRadius: 30))

                    .padding(.horizontal, 24)

                    
                    // Transition Message
                    VStack(spacing: 8) {
                        Text("That future is possible.")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("You just need the right system.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("LET ME SHOW YOU")
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
                    .disabled(successVision.isEmpty)
                    .opacity(successVision.isEmpty ? 0.5 : 1.0)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}

#Preview {
    SuccessVisionView(onContinue: {}, successVision: .constant(""))
}
