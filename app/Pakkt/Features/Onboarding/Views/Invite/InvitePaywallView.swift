import SwiftUI

// MARK: - Invite Step 8: Paywall
struct InviteStep8View: View {
    let onPurchase: () -> Void
    let onRestore: () -> Void
    
    @State private var showContent = false
    @State private var showLock = true
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Locked parchment visual
                ZStack {
                    // Parchment
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemGray6))
                        .frame(width: 200, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                    
                    // Lock overlay
                    if showLock {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 80, height: 80)
                                .shadow(color: .black.opacity(0.1), radius: 10)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.9)
                
                // Copy
                VStack(spacing: 16) {
                    Text("YOUR PACT IS SEALED")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("But Inactive")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                    
                    Text("Activate Pakkt+ to start your streak and sync with your pack")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Social pressure
                    HStack(spacing: 8) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("Everyone else is already in")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
                    .padding(.top, 8)
                }
                .opacity(showContent ? 1 : 0)
                
                // Pricing
                VStack(spacing: 12) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("$4")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.primary)
                        Text("/week")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Cancel anytime")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Buttons
                VStack(spacing: 16) {
                    Button(action: onPurchase) {
                        HStack(spacing: 12) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("ACTIVATE PAKKT+")
                                .font(.system(size: 16, weight: .bold))
                                .tracking(1.5)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .glassEffect(in: .rect(cornerRadius: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                        )
                    }
                    
                    Button(action: onRestore) {
                        Text("Restore Purchase")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
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
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep8View(
        onPurchase: {},
        onRestore: {}
    )
}
