import SwiftUI

struct OnboardingStep18View: View {
    let onContinue: () -> Void
    
    @State private var showContent = false
    @State private var currentIndex = 0
    @State private var inviteLink = "pakkt.app/join/gym-wolves-abc123"
    @State private var showCopyToast = false
    
    let inviteMethods: [InviteMethod] = [
        InviteMethod(
            title: "SHARE LINK",
            icon: "link",
            description: "Share a unique invite link",
            details: "Link expires in 24 hours\n5/10 spots remaining",
            actionLabel: "COPY LINK",
            tintColor: Color(hex: "#0066FF")
        ),
        InviteMethod(
            title: "DIRECT INVITE",
            icon: "person.crop.circle.badge.plus",
            description: "Invite from your contacts",
            details: "Recently contacted friends\nQuick select and send",
            actionLabel: "SELECT CONTACTS",
            tintColor: Color(hex: "#00D448")
        ),
        InviteMethod(
            title: "CUSTOM MESSAGE",
            icon: "text.bubble",
            description: "Personalize your invitation",
            details: "Write your own message\nExplain why they should join",
            actionLabel: "WRITE MESSAGE",
            tintColor: Color(hex: "#FF9500")
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("ASSEMBLE YOUR WOLVES")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("Choose how to invite your pack")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .padding(.top, 60)
                .padding(.bottom, 24)
                
                // Carousel
                VStack(spacing: 12) {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(inviteMethods.enumerated()), id: \.offset) { index, method in
                            InviteMethodCard(
                                method: method,
                                inviteLink: inviteLink,
                                onAction: {
                                    handleMethodAction(method)
                                }
                            )
                            .padding(.horizontal, 20)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Custom page indicators below carousel
                    HStack(spacing: 8) {
                        ForEach(0..<inviteMethods.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Bottom buttons
                VStack(spacing: 12) {
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
                    
                    Button(action: onContinue) {
                        Text("SKIP FOR NOW")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .overlay(
            Group {
                if showCopyToast {
                    VStack {
                        Text("Link copied!")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .glassEffect()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 60)
                    Spacer()
                }
            }
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
    
    private func handleMethodAction(_ method: InviteMethod) {
        if method.title == "SHARE LINK" {
            UIPasteboard.general.string = inviteLink
            showCopyToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showCopyToast = false
            }
        }
        // Other actions would be implemented here
    }
}

// MARK: - Invite Method Model
struct InviteMethod: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String
    let details: String
    let actionLabel: String
    let tintColor: Color
}

// MARK: - Invite Method Card
struct InviteMethodCard: View {
    let method: InviteMethod
    let inviteLink: String
    let onAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Icon header
            HStack {
                ZStack {
                    Circle()
                        .fill(method.tintColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: method.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(method.tintColor)
                }
                
                Spacer()
                
                Circle()
                    .fill(method.tintColor.opacity(0.2))
                    .frame(width: 12, height: 12)
            }
            
            Divider()
                .background(Color.secondary.opacity(0.2))
            
            // Content
            VStack(alignment: .leading, spacing: 16) {
                Text(method.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(1.5)
                
                Text(method.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                // Details box
                if method.title == "SHARE LINK" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(inviteLink)
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text(method.details)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                } else {
                    Text(method.details)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                }
            }
            
            Spacer()
            
            // Action button
            Button(action: onAction) {
                HStack(spacing: 8) {
                    Text(method.actionLabel)
                        .font(.system(size: 15, weight: .bold))
                        .tracking(1.0)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(method.tintColor)
                .cornerRadius(12)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .glassEffect(in: .rect(cornerRadius: 24))
    }
}

#Preview {
    OnboardingStep18View(onContinue: {})
}
