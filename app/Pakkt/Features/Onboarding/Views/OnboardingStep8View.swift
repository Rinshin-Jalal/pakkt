import SwiftUI

// MARK: - Step 8: The Brotherhood
struct OnboardingStep8View: View {
    @State private var showContent = false
    @State private var currentMoment: Int = 0
    let onContinue: () -> Void
    
    let moments = [
        BrotherhoodMoment(
            icon: "message.fill",
            title: "Trash Talk",
            message: "Jake: \"Bro where you at??\"\nMike: \"He's scared of leg day\"",
            color: "#FF9500"
        ),
        BrotherhoodMoment(
            icon: "hands.clap.fill",
            title: "Celebration",
            message: "Sarah crushed it!\n10-day streak",
            color: "#00D448"
        ),
        BrotherhoodMoment(
            icon: "lock.fill",
            title: "Jail Time",
            message: "Mike locked out\n47 minutes remaining",
            color: "#FF3B30"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                // Header
                VStack(spacing: 6) {
                    Text("THE BROTHERHOOD")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(1.5)
                    
                    Text("Your pack has your back")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 24)
                
                // Moments carousel
                TabView(selection: $currentMoment) {
                    ForEach(0..<moments.count, id: \.self) { index in
                        BrotherhoodMomentCard(moment: moments[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 320)
                .opacity(showContent ? 1 : 0)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<moments.count, id: \.self) { index in
                        Circle()
                            .fill(currentMoment == index ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.top, 12)
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 20)
                
                // Bottom text
                VStack(spacing: 6) {
                    Text("And your wallet. And your phone.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("The fun, competitive energy you need")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                
                Spacer().frame(height: 40)
                
                // Continue button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("LET'S GET STARTED")
                            .font(.system(size: 15, weight: .bold))
                            .tracking(1.0)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            
            // Auto-cycle through moments
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
                withAnimation {
                    currentMoment = (currentMoment + 1) % moments.count
                }
            }
        }
    }
}

// MARK: - Brotherhood Moment Model
struct BrotherhoodMoment {
    let icon: String
    let title: String
    let message: String
    let color: String
}

// MARK: - Brotherhood Moment Card
struct BrotherhoodMomentCard: View {
    let moment: BrotherhoodMoment
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                // Large icon
                ZStack {
                    Circle()
                        .fill(Color(hex: moment.color).opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: moment.icon)
                        .font(.system(size: 38, weight: .semibold))
                        .foregroundColor(Color(hex: moment.color))
                }
                
                Text(moment.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Message
                Text(moment.message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 28)
                
                // Action indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: moment.color))
                        .frame(width: 6, height: 6)
                    
                    Text("Live now")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 28)
        }
        .frame(maxWidth: 340)
        .glassEffect(in: .rect(cornerRadius: 24))
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingStep8View(onContinue: {})
}
