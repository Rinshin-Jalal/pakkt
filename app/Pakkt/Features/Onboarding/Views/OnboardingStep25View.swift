import SwiftUI

struct OnboardingStep25View: View {
    let onContinue: () -> Void
    
    @State private var signature: [CGPoint] = []
    @State private var currentStroke: [CGPoint] = []
    @State private var hasSignature: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 16) {
                Text("SIGN THE PACT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("This is real. No backing out.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 32)
            
            // Signature Area
            VStack(spacing: 12) {
                ZStack {
                    // Background
                    Rectangle()
                        .fill(Color.clear)
                    
                    // Signature Canvas
                    Canvas { context, size in
                        var path = Path()
                        
                        // Draw all completed strokes
                        if !signature.isEmpty {
                            path.move(to: signature[0])
                            for point in signature.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        
                        // Draw current stroke
                        if !currentStroke.isEmpty {
                            path.move(to: currentStroke[0])
                            for point in currentStroke.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        
                        context.stroke(
                            path,
                            with: .color(.blue),
                            lineWidth: 3
                        )
                    }
                    
                    // Placeholder text
                    if !hasSignature {
                        Text("Sign here")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.secondary.opacity(0.3))
                    }
                }
                .frame(height: 200)
                .glassEffect(in: .rect(cornerRadius: 30))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            currentStroke.append(value.location)
                            hasSignature = true
                        }
                        .onEnded { _ in
                            signature.append(contentsOf: currentStroke)
                            currentStroke = []
                        }
                )
                
                // Clear button
                if hasSignature {
                    Button {
                        signature = []
                        currentStroke = []
                        hasSignature = false
                    } label: {
                        Text("Clear")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            
            Spacer()
            
            // Continue Button
            Button(action: onContinue) {
                Text("SEAL THE PACT")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(hasSignature ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
            }
            .disabled(!hasSignature)
            .opacity(hasSignature ? 1.0 : 0.5)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    OnboardingStep25View(onContinue: {})
}
