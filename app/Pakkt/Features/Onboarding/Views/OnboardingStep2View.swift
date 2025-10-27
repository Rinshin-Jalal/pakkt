import SwiftUI

// MARK: - Step 2: The Social Truth
struct OnboardingStep2View: View {
    @State private var showContent = false
    @State private var currentScenario: Int = 0
    @State private var selectedVote: VoteOption? = nil
    let onContinue: () -> Void
    
    enum VoteOption {
        case dontFine, fine, wait
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top instruction
                VStack(spacing: 12) {
                    Text("SWIPE TO SEE THE DIFFERENCE")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(1.0)
                        .padding(.top, 20)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(currentScenario == 0 ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                        Circle()
                            .fill(currentScenario == 1 ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                // Feed container
                TabView(selection: $currentScenario) {
                    // Scenario 1: Alone - Empty feed
                    AloneFeedView()
                        .tag(0)
                    
                    // Scenario 2: With Pack - Live accountability
                    WithPackFeedView(selectedVote: $selectedVote)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .opacity(showContent ? 1 : 0)
                
                // Bottom text
                VStack(spacing: 12) {
                    if currentScenario == 0 {
                        VStack(spacing: 4) {
                            Text("Alone? You fail.")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Nobody sees. Nobody cares.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .transition(.opacity)
                    } else {
                        VStack(spacing: 4) {
                            Text("With pack? You show up.")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Every. Single. Time.")
                                .font(.system(size: 15, weight: .medium))
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
            
            // Auto-advance to show the difference
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentScenario = 1
                }
            }
        }
    }
}

// MARK: - Alone Feed (Empty, no pack)
struct AloneFeedView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)
                
                // Empty missed check-in - YOUR card (right aligned)
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Spacer()
                        
                        Text("7:42 AM")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text("You")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Spacer(minLength: 50)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("💪 Morning Workout")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 0)
                                    .padding(.top, 16)
                                    .padding(.bottom, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(hex: "#FF3B30"))
                                    Text("Missed check-in")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "wind")
                                        .font(.system(size: 32))
                                        .foregroundColor(.secondary.opacity(0.3))
                                    
                                    Text("No pack to see this")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary.opacity(0.7))
                                    
                                    Text("No consequences")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                            }
                            .padding(20)
                        }
                        .glassEffect(in: .rect(cornerRadius: 30))
                    }
                }
                .padding(.horizontal, 0)
                .padding(.trailing, 16)
                .padding(.leading, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
    }
}

// MARK: - With Pack Feed (Live accountability)
struct WithPackFeedView: View {
    @Binding var selectedVote: OnboardingStep2View.VoteOption?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)
                
                // Jake's successful check-in - LEFT aligned (other person)
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Text("Jake")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("7:05 AM")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        StatusBadge(icon: "checkmark.circle.fill", color: Color(hex: "#00D448"))
                        
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("💪 Morning Workout")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 0)
                                    .padding(.top, 16)
                                    .padding(.bottom, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Crushed it! 3-day streak 🔥")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding(20)
                        }
                        .glassEffect(in: .rect(cornerRadius: 30))
                        
                        Spacer(minLength: 40)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.trailing, 0)
                .padding(.leading, 0)
                
                Spacer().frame(height: 10)
                
                // YOUR missed check-in with voting - RIGHT aligned
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Spacer()
                        
                        StatusBadge(icon: "hand.raised.fill", color: Color(hex: "#FF9500"))
                        
                        Text("7:42 AM")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text("You")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Spacer(minLength: 50)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("💪 Morning Workout")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                                Spacer()
                                
                                Text("6h left")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            HStack {
                                Text("Check-In Failed")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 16))
                                    Text("1hr")
                                        .font(.system(size: 20, weight: .bold))
                                }
                                .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            // Voting section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Should You be jailed?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    GeometryReader { geometry in
                                        HStack(spacing: 2) {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: "#00D448"))
                                                .frame(width: geometry.size.width * (1.0 / 5.0))
                                            
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: "#FF3B30"))
                                                .frame(width: geometry.size.width * (3.0 / 5.0))
                                            
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white.opacity(0.1))
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .frame(height: 20)
                                    
                                    HStack(spacing: 16) {
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(Color(hex: "#00D448"))
                                                .frame(width: 8, height: 8)
                                            Text("Don't Jail")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(Color(hex: "#FF3B30"))
                                                .frame(width: 8, height: 8)
                                            Text("Jail")
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    
                                    Text("4/5 pack members voted")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                
                                Text("You can't vote on your own check-in")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.5))
                                    .italic()
                            }
                        }
                        .padding(20)
                        .glassEffect(in: .rect(cornerRadius: 30))
                    }
                }
                .padding(.horizontal, 0)
                .padding(.trailing, 16)
                .padding(.leading, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
    }
}

// MARK: - Status Badge (copied from FeedView)
struct StatusBadge: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(color)
    }
}

#Preview {
    OnboardingStep2View(onContinue: {})
}
