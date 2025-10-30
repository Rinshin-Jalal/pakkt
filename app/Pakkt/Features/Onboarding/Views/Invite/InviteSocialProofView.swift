import SwiftUI

// MARK: - Invite Step 3: Emotional Pitch
struct InviteStep3View: View {
    let onContinue: () -> Void
    
    @State private var showContent = false
    @State private var showComparison = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Illustration comparison
                HStack(spacing: 24) {
                    // Before: Unfocused
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "phone.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red.opacity(0.6))
                        }
                        
                        Text("Solo")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .opacity(showComparison ? 1 : 0)
                    .offset(x: showComparison ? 0 : -20)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .opacity(showComparison ? 1 : 0)
                    
                    // After: Focused
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "figure.run")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                        }
                        
                        Text("With Pack")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .opacity(showComparison ? 1 : 0)
                    .offset(x: showComparison ? 0 : 20)
                }
                .padding(.vertical, 32)
                
                // Copy
                VStack(spacing: 16) {
                    Text("PEOPLE IN PACKS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("Stay Consistent 8x Longer")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    VStack(spacing: 8) {
                        Text("Science calls it 'social accountability'")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("We call it power")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onContinue) {
                    HStack(spacing: 12) {
                        Text("SEE YOUR PACT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                showComparison = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep3View(onContinue: {})
}
