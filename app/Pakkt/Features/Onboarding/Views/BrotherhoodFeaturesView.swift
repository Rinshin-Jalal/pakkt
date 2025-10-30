import SwiftUI

// MARK: - Step 13: Brotherhood Features (Relief - Breathing Step)
struct BrotherhoodFeaturesView: View {
    let onContinue: () -> Void
    @State private var showCards = [false, false, false]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Header
                    VStack(spacing: 12) {
                        Text("YOUR PACK IS MORE THAN CONSEQUENCES")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .tracking(2.0)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    
                    // Feature 1: Trash Talk
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                            
                            Text("TRASH TALK")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Roast friends who miss.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Hype those who show up.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    .opacity(showCards[0] ? 1 : 0)
                    .offset(y: showCards[0] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showCards[0])
                    
                    // Feature 2: Vote & Jail
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)
                            
                            Text("JAIL YOUR FRIENDS")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Vote on consequences.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Democracy + Stakes.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    .opacity(showCards[1] ? 1 : 0)
                    .offset(y: showCards[1] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showCards[1])
                    
                    // Feature 3: Celebrate
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.green)
                            
                            Text("CELEBRATE WINS")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .tracking(1.0)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Streak milestones.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Pack victories.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(in: .rect(cornerRadius: 30))
                    .padding(.horizontal, 24)
                    .opacity(showCards[2] ? 1 : 0)
                    .offset(y: showCards[2] ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showCards[2])
                    
                    // Selling Point
                    VStack(spacing: 8) {
                        Text("It's accountability")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("that's actually fun.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Continue Button
                    Button(action: onContinue) {
                        HStack(spacing: 8) {
                            Text("WHY THIS WORKS")
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
        }
        .onAppear {
            for index in 0..<showCards.count {
                showCards[index] = true
            }
        }
    }
}

#Preview {
    BrotherhoodFeaturesView(onContinue: {})
}
