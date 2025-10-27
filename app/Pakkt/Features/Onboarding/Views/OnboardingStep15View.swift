import SwiftUI

struct OnboardingStep15View: View {
    @Binding var successVision: String
    let onContinue: () -> Void
    
    @State private var visionText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("SUCCESS VISION")
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.5))
                
                Text("Imagine yourself 30 days from now")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("What does success look like?")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Vision Input Area
            VStack(alignment: .leading, spacing: 12) {
                Text("DESCRIBE YOUR VISION")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.0)
                    .foregroundColor(.white.opacity(0.5))
                
                ZStack(alignment: .topLeading) {
                    if visionText.isEmpty {
                        Text("I wake up feeling energized. I achieve my goal and feel proud. My pack is proud of me too...")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    }
                    
                    TextEditor(text: $visionText)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 180)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .focused($isTextFieldFocused)
                        .onChange(of: visionText) { _, newValue in
                            successVision = newValue
                        }
                }
                .glassEffect(in: .rect(cornerRadius: 16))
                
                Text("\(visionText.count) / 500")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                if !visionText.isEmpty {
                    isTextFieldFocused = false
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
            .opacity(!visionText.isEmpty ? 1 : 0.5)
            .disabled(visionText.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}



#Preview {
    OnboardingStep15View(
        successVision: .constant(""),
        onContinue: {}
    )
}
