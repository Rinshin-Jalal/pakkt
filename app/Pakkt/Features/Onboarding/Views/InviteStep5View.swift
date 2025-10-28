import SwiftUI

// MARK: - Invite Step 5: Signature Canvas
struct InviteStep5View: View {
    let onComplete: () -> Void
    
    @State private var signaturePath = Path()
    @State private var currentPath = Path()
    @State private var showContent = false
    @State private var isSealing = false
    @State private var sealingProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("SEAL YOUR COMMITMENT")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("Draw Your Signature")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                }
                .opacity(showContent ? 1 : 0)
                
                // Signature canvas
                ZStack {
                    // Parchment background
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                    
                    if isSealing {
                        // Sealing animation
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("SEALING...")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(2.0)
                        }
                    } else {
                        // Canvas
                        Canvas { context, size in
                            context.stroke(
                                signaturePath,
                                with: .color(.primary),
                                lineWidth: 3
                            )
                            context.stroke(
                                currentPath,
                                with: .color(.primary),
                                lineWidth: 3
                            )
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let point = value.location
                                    if currentPath.isEmpty {
                                        currentPath.move(to: point)
                                    } else {
                                        currentPath.addLine(to: point)
                                    }
                                }
                                .onEnded { _ in
                                    signaturePath.addPath(currentPath)
                                    currentPath = Path()
                                }
                        )
                        
                        // Placeholder text
                        if signaturePath.isEmpty {
                            Text("Sign here")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary.opacity(0.5))
                                .italic()
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                
                // Clear button
                if !signaturePath.isEmpty && !isSealing {
                    Button(action: {
                        signaturePath = Path()
                        currentPath = Path()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Clear")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.secondary)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
                
                // CTA Button
                Button(action: handleSign) {
                    HStack(spacing: 12) {
                        Image(systemName: "signature")
                            .font(.system(size: 18, weight: .semibold))
                        Text("SEAL PACT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                signaturePath.isEmpty ? Color.primary.opacity(0.2) : Color.orange.opacity(0.5),
                                lineWidth: 1
                            )
                    )
                }
                .disabled(signaturePath.isEmpty || isSealing)
                .opacity(signaturePath.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
    
    private func handleSign() {
        withAnimation {
            isSealing = true
        }
        
        // Simulate sealing animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                onComplete()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep5View(onComplete: {})
}
