import SwiftUI

// MARK: - Invite Step 6: Pack Seal Screen
struct InviteStep6View: View {
    let packName: String
    let memberCount: Int
    let nextCheckInTime: String
    let memberNames: [String]
    let onActivate: () -> Void
    
    @State private var showContent = false
    @State private var showSignatures = false
    @State private var confettiTrigger = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                }
                .scaleEffect(confettiTrigger ? 1.0 : 0.5)
                .opacity(showContent ? 1 : 0)
                
                // Header
                VStack(spacing: 12) {
                    Text("YOU'RE NOW PART OF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    Text(packName)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.0)
                }
                .opacity(showContent ? 1 : 0)
                
                // Signatures parchment
                VStack(spacing: 20) {
                    Text("PACK SIGNATURES")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(memberNames.enumerated()), id: \.offset) { index, name in
                            HStack(spacing: 12) {
                                Image(systemName: "signature")
                                    .font(.system(size: 16))
                                    .foregroundColor(index == memberNames.count - 1 ? .green : .blue)
                                
                                Text(name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if index == memberNames.count - 1 {
                                    Text("YOU")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.green.opacity(0.15))
                                        )
                                }
                            }
                            .opacity(showSignatures ? 1 : 0)
                            .offset(x: showSignatures ? 0 : -20)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                value: showSignatures
                            )
                        }
                    }
                }
                .padding(24)
                .glassEffect(in: .rect(cornerRadius: 30))
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                
                // Next check-in info
                VStack(spacing: 8) {
                    Text("Next check-in")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text(nextCheckInTime)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA Button
                Button(action: onActivate) {
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("ACTIVATE MY PACT")
                            .font(.system(size: 16, weight: .bold))
                            .tracking(1.5)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                confettiTrigger = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                showSignatures = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    InviteStep6View(
        packName: "Morning Warriors",
        memberCount: 4,
        nextCheckInTime: "Tomorrow at 6:00 AM",
        memberNames: ["Alex", "Jordan", "Sam", "You"],
        onActivate: {}
    )
}
