import SwiftUI

// MARK: - Step 5: Pack Definition
struct OnboardingStep5View: View {
    @State private var showContent = false
    @State private var packSize: Int = 3
    @State private var animatePeople = false
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Text("WHAT'S A PACK?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("Your accountability crew")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 32)
                
                // Main card
                VStack(spacing: 28) {
                    // Pack visualization
                    ZStack {
                        // People icons arranged in circle
                        ForEach(0..<packSize, id: \.self) { index in
                            let angle = (Double(index) / Double(packSize)) * 2 * .pi - .pi / 2
                            let radius: CGFloat = 70
                            
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#00D448").opacity(0.15))
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(Color(hex: "#00D448"))
                            }
                            .offset(
                                x: cos(angle) * radius,
                                y: sin(angle) * radius
                            )
                            .scaleEffect(animatePeople ? 1.0 : 0.3)
                            .opacity(animatePeople ? 1.0 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.08), value: animatePeople)
                        }
                        
                        // Center connection indicator
                        Circle()
                            .stroke(Color(hex: "#00D448").opacity(0.2), lineWidth: 2)
                            .frame(width: 160, height: 160)
                            .scaleEffect(animatePeople ? 1.0 : 0.5)
                            .opacity(animatePeople ? 1.0 : 0)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: animatePeople)
                    }
                    .frame(height: 200)
                    
                    // Description
                    VStack(spacing: 12) {
                        Text("\(packSize)-\(min(packSize + 7, 10)) friends")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("who won't let you quit")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    // Pack size selector
                    VStack(spacing: 16) {
                        Text("TAP TO CHANGE SIZE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.0)
                        
                        HStack(spacing: 12) {
                            ForEach([3, 5, 7], id: \.self) { size in
                                Button(action: {
                                    withAnimation {
                                        packSize = size
                                        animatePeople = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            animatePeople = true
                                        }
                                    }
                                }) {
                                    Text("\(size)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(packSize == size ? .white : .secondary)
                                        .frame(width: 60, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(packSize == size ? Color(hex: "#00D448").opacity(0.3) : Color.secondary.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 40)
                .frame(maxWidth: 360)
                .glassEffect(in: .rect(cornerRadius: 28))
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer()
                
                // Bottom insight
                Text("This is about friends, not a solo app")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Continue button
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
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    animatePeople = true
                }
            }
        }
    }
}

#Preview {
    OnboardingStep5View(onContinue: {})
}
