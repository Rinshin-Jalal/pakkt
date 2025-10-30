import SwiftUI

// MARK: - Invite Step 4.5: Others Have Signed
struct InviteStep4_5View: View {
    let packName: String
    let memberSignatures: [PackMemberSignature]
    let onContinue: () -> Void
    
    @State private var showContent = false
    @State private var showSignatures = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("YOUR PACK HAS SIGNED")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text("Join Them")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                }
                .opacity(showContent ? 1 : 0)
                
                // Parchment with signatures
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("PACT SIGNATURES")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                        .background(Color.primary.opacity(0.2))
                    
                    // Signatures list
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(memberSignatures.enumerated()), id: \.element.id) { index, signature in
                            SignatureRow(
                                name: signature.memberName,
                                signatureStyle: signature.signatureStyle,
                                timestamp: signature.timestamp
                            )
                            .opacity(showSignatures ? 1 : 0)
                            .offset(x: showSignatures ? 0 : -20)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                value: showSignatures
                            )
                        }
                    }
                    
                    Divider()
                        .background(Color.primary.opacity(0.2))
                        .padding(.top, 8)
                    
                    // Your turn indicator
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.orange)
                        
                        Text("Your signature is next")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.95)
                
                Spacer()
                
                // CTA Button
                Button(action: onContinue) {
                    HStack(spacing: 12) {
                        Image(systemName: "signature")
                            .font(.system(size: 18, weight: .semibold))
                        Text("SIGN THE PACT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
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
                showSignatures = true
            }
        }
    }
}

// MARK: - Supporting Views
private struct SignatureRow: View {
    let name: String
    let signatureStyle: String
    let timestamp: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("Signed")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Models
struct PackMemberSignature: Identifiable {
    let id = UUID()
    let memberName: String
    let signatureStyle: String
    let timestamp: String
}

// MARK: - Preview
#Preview {
    InviteStep4_5View(
        packName: "Morning Warriors",
        memberSignatures: [
            PackMemberSignature(
                memberName: "ALEX",
                signatureStyle: "Alex Chen",
                timestamp: "Signed 2 days ago"
            ),
            PackMemberSignature(
                memberName: "JORDAN",
                signatureStyle: "Jordan Smith",
                timestamp: "Signed yesterday"
            ),
            PackMemberSignature(
                memberName: "TAYLOR",
                signatureStyle: "Taylor Kim",
                timestamp: "Signed 3 hours ago"
            )
        ],
        onContinue: {}
    )
}
