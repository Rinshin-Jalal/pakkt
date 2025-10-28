import SwiftUI

struct OnboardingStep33View: View {
    let onContinue: () -> Void
    @State private var isProcessing = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Pack confidence header
                VStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.blue)
                        .padding(.bottom, 8)
                    
                    Text("JOIN THE PACK")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundStyle(.primary)
                    
                    Text("Your boys are waiting")
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 40)
                
                // Pricing card
                VStack(spacing: 24) {
                    // Price
                    VStack(spacing: 8) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$4")
                                .font(.system(size: 56, weight: .heavy))
                                .foregroundStyle(.blue)
                            Text("/week")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("FIRST WEEK FREE")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background {
                                Capsule()
                                    .fill(.blue.opacity(0.15))
                            }
                    }
                    .padding(.bottom, 8)
                    
                    // Social proof stats
                    VStack(spacing: 12) {
                        SubscriptionStatRow(icon: "person.3.fill", text: "47,823 packs active")
                        SubscriptionStatRow(icon: "star.fill", text: "4.8 stars")
                        SubscriptionStatRow(icon: "checkmark.shield.fill", text: "Cancel anytime")
                    }
                }
                .padding(32)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Subscribe button
                Button(action: {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isProcessing = false
                        onContinue()
                    }
                }) {
                    HStack(spacing: 8) {
                        if isProcessing {
                            ProgressView()
                                .tint(.primary)
                        } else {
                            Text("START FREE WEEK")
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
                .disabled(isProcessing)
                .padding(.horizontal, 24)
                .buttonStyle(.glassProminent)
                
                // Legal text
                Text("Automatically renews at $4/week. Cancel anytime.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.horizontal, 40)
                
                // Skip option
                Button(action: onContinue) {
                    Text("Maybe later")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .underline()
                }
                .padding(.top, 16)
                .padding(.bottom, 50)
            }
        }
    }
}

private struct SubscriptionStatRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingStep33View(onContinue: {})
}
