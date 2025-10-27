import SwiftUI

struct OnboardingStep16View: View {
    let selectedGoal: String
    let selectedWhy: String
    let estimatedCost: Double?
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Title
                VStack(spacing: 12) {
                    Text("YOUR INVESTMENT")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .tracking(2.0)
                    
                    Text("You've invested time thinking about this.\nReady to make it real?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Investment Summary
                VStack(spacing: 12) {
                    // Goal
                    InvestmentCard(
                        title: "YOUR GOAL",
                        value: selectedGoal,
                        icon: "target"
                    )
                    
                    // Why
                    InvestmentCard(
                        title: "YOUR WHY",
                        value: selectedWhy,
                        icon: "heart.fill"
                    )
                    
                    // Cost
                    InvestmentCard(
                        title: "YOUR COST",
                        value: formatCost(),
                        icon: "dollarsign.circle.fill"
                    )
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("MAKE IT REAL")
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
    
    private func formatCost() -> String {
        guard let cost = estimatedCost else {
            return "Not calculated"
        }
        return "$\(Int(cost))/month if you slip up"
    }
}

struct InvestmentCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.1))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(14)
        .glassEffect(in: .rect(cornerRadius: 14))
    }
}

#Preview {
    OnboardingStep16View(
        selectedGoal: "Wake up at 6 AM",
        selectedWhy: "More productive mornings",
        estimatedCost: 120,
        onContinue: {}
    )
}
