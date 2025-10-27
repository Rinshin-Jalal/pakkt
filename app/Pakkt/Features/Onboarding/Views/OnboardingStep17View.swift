import SwiftUI

struct OnboardingStep17View: View {
    let onContinue: () -> Void
    @State private var packName: String = ""
    @State private var selectedSize: Int = 5
    @State private var selectedGoalFrequency: String = "daily"
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Title
                VStack(spacing: 12) {
                    Text("PACK FOUNDATION")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("Now let's build your accountability crew")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Pack Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("PACK NAME")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    TextField("Enter pack name", text: $packName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.secondary.opacity(0.1))
                        )
                        .focused($isNameFieldFocused)
                }
                .padding(.horizontal, 24)
                
                // Pack Size Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("PACK SIZE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        Text("\(selectedSize) MEMBERS")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Slider(value: Binding(
                            get: { Double(selectedSize) },
                            set: { selectedSize = Int($0) }
                        ), in: 3...10, step: 1)
                            .tint(.primary.opacity(0.3))
                        
                        HStack {
                            Text("3")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("10")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(16)
                    .glassEffect(in: .rect(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                
                // Goal Type Selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("GOAL TYPE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        GoalTypeButton(
                            title: "DAILY",
                            icon: "sun.max.fill",
                            isSelected: selectedGoalFrequency == "daily"
                        ) {
                            selectedGoalFrequency = "daily"
                        }
                        
                        GoalTypeButton(
                            title: "WEEKLY",
                            icon: "calendar",
                            isSelected: selectedGoalFrequency == "weekly"
                        ) {
                            selectedGoalFrequency = "weekly"
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Continue Button
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
                .disabled(packName.isEmpty)
                .opacity(packName.isEmpty ? 0.5 : 1.0)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            isNameFieldFocused = true
        }
    }
}

struct GoalTypeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.secondary.opacity(0.1) : Color.clear)
            )
        }
    }
}

#Preview {
    OnboardingStep17View(onContinue: {})
}
