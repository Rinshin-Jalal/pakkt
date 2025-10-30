import SwiftUI

struct SignPackPactView: View {
    let onContinue: () -> Void

    @State private var signature: [CGPoint] = []
    @State private var currentStroke: [CGPoint] = []
    @State private var hasSignature: Bool = false
    @State private var isSealed: Bool = false
    @State private var scale: CGFloat = 1.0
    
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
            
            // Seal Animation (shown after signing)
            if isSealed {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .scaleEffect(scale)

                    Text("PACT SEALED")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)

                    Text("No backing out now.")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)

                    VStack(spacing: 8) {
                        Text("SIGNED BY")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)

                        Text("You")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()

            // Continue Button
            if !isSealed {
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

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        onContinue()
                    }
                } label: {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    SignPackPactView(onContinue: {})
}
