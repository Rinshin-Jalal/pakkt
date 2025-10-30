import SwiftUI

// MARK: - Step 4: Why Willpower Fails (Pain - Breathing Step)
struct WhyWillpowerFailsView: View {
    let onContinue: () -> Void
    @State private var showDiagram = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("YOUR BRAIN IS DESIGNED")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("TO AVOID PAIN")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                
                // Brain Diagram
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Image(systemName: "circle")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                            Text("Comfort Zone")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 50))
                            .foregroundColor(.primary)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "circle")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                            Text("Comfort Zone")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Willpower")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.red)
                        }
                        
                        Text("(depletes in 2hrs)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                .opacity(showDiagram ? 1 : 0)
                .scaleEffect(showDiagram ? 1 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showDiagram)
                
                // Body Text
                VStack(spacing: 12) {
                    Text("Motivation fades.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("Excuses appear.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("You rationalize quitting.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("That's why you need")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("EXTERNAL consequences.")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.primary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .opacity(showText ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: showText)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("I GET IT NOW")
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
            showDiagram = true
            showText = true
        }
    }
}

#Preview {
    WhyWillpowerFailsView(onContinue: {})
}
