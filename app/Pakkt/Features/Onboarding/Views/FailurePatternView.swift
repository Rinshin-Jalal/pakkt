import SwiftUI

// MARK: - Step 5: Failure Pattern (Pain)
struct FailurePatternView: View {
    let onContinue: () -> Void
    @Binding var failureCount: Int
    @State private var displayedCount: Int = 15
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Question
                Text("How many times have you tried and quit?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Big Number Display
                Text("\(displayedCount)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.primary)
                    .contentTransition(.numericText())
                
                Text("TIMES")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(1.5)
                
                // Slider
                VStack(spacing: 16) {
                    Slider(value: Binding(
                        get: { Double(failureCount) },
                        set: { newValue in
                            failureCount = Int(newValue)
                            displayedCount = Int(newValue)
                        }
                    ), in: 2...20, step: 1)
                        .tint(.blue)
                    
                    HStack {
                        Text("2")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("20+")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                
                // Dynamic Response Text
                VStack(spacing: 12) {
                    Text("That's \(displayedCount) times you've")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("disappointed yourself.")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                        .frame(height: 8)
                    
                    Text("It's not your fault—")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("it's your method.")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("UNFORTUNATELY")
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
            displayedCount = failureCount
        }
    }
}

#Preview {
    FailurePatternView(onContinue: {}, failureCount: .constant(15))
}
