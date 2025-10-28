import SwiftUI

struct OnboardingStep26View: View {
    let onContinue: () -> Void
    
    @State private var isSealed: Bool = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Text(isSealed ? "PACT SEALED" : "SEAL THE PACT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(isSealed ? "No backing out now." : "Tap to confirm commitment")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 48)
            
            // Seal Visual
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isSealed = true
                    scale = 1.1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scale = 1.0
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onContinue()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(isSealed ? Color.blue.opacity(0.2) : Color.clear)
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: isSealed ? "checkmark.seal.fill" : "seal")
                        .font(.system(size: 80))
                        .foregroundColor(isSealed ? .blue : .secondary)
                }
                .scaleEffect(scale)
            }
            .disabled(isSealed)
            .padding(.bottom, 48)
            
            // Member Signatures (placeholder)
            VStack(spacing: 8) {
                Text("SIGNED BY")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 4) {
                    Text("You")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    OnboardingStep26View(onContinue: {})
}
