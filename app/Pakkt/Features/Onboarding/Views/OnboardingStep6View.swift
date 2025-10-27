import SwiftUI

// MARK: - Step 6: The Power of Consequences
struct OnboardingStep6View: View {
    @State private var showContent = false
    @State private var currentView: ConsequenceView = .willpower
    let onContinue: () -> Void
    
    enum ConsequenceView {
        case willpower, consequences
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top instruction
                VStack(spacing: 12) {
                    Text("SWIPE TO SEE WHY")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.0)
                        .padding(.top, 20)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(currentView == .willpower ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                        Circle()
                            .fill(currentView == .consequences ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                // Content
                TabView(selection: $currentView) {
                    // View 1: Willpower Fails
                    WillpowerView()
                        .tag(ConsequenceView.willpower)
                    
                    // View 2: Consequences Work
                    ConsequencesView()
                        .tag(ConsequenceView.consequences)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .opacity(showContent ? 1 : 0)
                
                // Bottom tagline
                VStack(spacing: 12) {
                    if currentView == .willpower {
                        Text("Willpower fails.")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .transition(.opacity)
                    } else {
                        VStack(spacing: 4) {
                            Text("Real stakes work.")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Phone jail screams.")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .transition(.opacity)
                    }
                }
                .frame(height: 80)
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
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
            
            // Auto-advance
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentView = .consequences
                }
            }
        }
    }
}

// MARK: - Willpower View (Fails)
struct WillpowerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 28) {
                // Icon
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.5))
                
                // Title
                Text("Just willpower")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Stats/outcomes
                VStack(spacing: 16) {
                    OutcomeRow(
                        icon: "xmark.circle",
                        text: "Skip gym → Feel bad",
                        color: Color.secondary.opacity(0.6)
                    )
                    
                    OutcomeRow(
                        icon: "moon.zzz",
                        text: "Maybe tomorrow...",
                        color: Color.secondary.opacity(0.6)
                    )
                    
                    OutcomeRow(
                        icon: "arrow.triangle.2.circlepath",
                        text: "Repeat cycle forever",
                        color: Color.secondary.opacity(0.6)
                    )
                }
                .padding(.horizontal, 32)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: 360)
            .glassEffect(in: .rect(cornerRadius: 28))
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

// MARK: - Consequences View (Works)
struct ConsequencesView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 28) {
                // Icon
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(Color(hex: "#FF3B30"))
                    
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(Color(hex: "#00D448"))
                }
                
                // Title
                Text("Real consequences")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Stats/outcomes
                VStack(spacing: 16) {
                    OutcomeRow(
                        icon: "lock.fill",
                        text: "Skip gym → 1hr phone jail",
                        color: Color(hex: "#FF3B30")
                    )
                    
                    OutcomeRow(
                        icon: "person.3.fill",
                        text: "Your boys see everything",
                        color: Color(hex: "#00D448")
                    )
                    
                    OutcomeRow(
                        icon: "checkmark.circle.fill",
                        text: "Actually show up",
                        color: Color(hex: "#0066FF")
                    )
                }
                .padding(.horizontal, 32)
            }
            .padding(.vertical, 40)
            .frame(maxWidth: 360)
            .glassEffect(in: .rect(cornerRadius: 28))
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

// MARK: - Outcome Row
struct OutcomeRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(text)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingStep6View(onContinue: {})
}
