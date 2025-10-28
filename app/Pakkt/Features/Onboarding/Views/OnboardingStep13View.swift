import SwiftUI

struct OnboardingStep13View: View {
    let onContinue: () -> Void
    @State private var vulnerabilityLevel: Double = 3
    
    let vulnerabilityOptions: [(level: Int, title: String, subtitle: String)] = [
        (1, "Hide my failures", "Nobody needs to know"),
        (3, "Share struggles", "My close friends only"),
        (5, "Public accountability", "Everyone can see")
    ]
    
    var currentOption: (level: Int, title: String, subtitle: String) {
        let level = Int(vulnerabilityLevel.rounded())
        return vulnerabilityOptions.first { $0.level == level } ?? vulnerabilityOptions[1]
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("HOW VULNERABLE ARE YOU?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .padding(.top, 60)
                    
                    Text("How comfortable are you letting friends see you fail?")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Vulnerability Meter
                VStack(spacing: 32) {
                    // Heart icon
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red.opacity(0.2 + (vulnerabilityLevel / 5.0) * 0.6))
                        .animation(.easeInOut(duration: 0.3), value: vulnerabilityLevel)
                    
                    // Current selection display
                    VStack(spacing: 8) {
                        Text(currentOption.title.uppercased())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(currentOption.subtitle)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Level \(currentOption.level)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.top, 4)
                    }
                    .animation(.easeInOut(duration: 0.2), value: vulnerabilityLevel)
                    
                    // Slider
                    VStack(spacing: 16) {
                        Slider(value: $vulnerabilityLevel, in: 1...5, step: 2)
                            .tint(.white.opacity(0.3))
                            .padding(.horizontal, 40)
                        
                        // Level indicators
                        HStack {
                            ForEach([1, 3, 5], id: \.self) { level in
                                VStack(spacing: 4) {
                                    Circle()
                                        .fill(vulnerabilityLevel >= Double(level) - 0.5 ? Color.white : Color.white.opacity(0.2))
                                        .frame(width: 8, height: 8)
                                    
                                    Text("\(level)")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Info box
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.4))
                        
                        Text("Higher vulnerability = Stronger accountability")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(16)
                .glassEffect(in: .rect(cornerRadius: 12))
                .padding(.horizontal, 20)
                
                // Continue button
                Button(action: onContinue) {
                    Text("CONTINUE")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.glass)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingStep13View(onContinue: {})
}
