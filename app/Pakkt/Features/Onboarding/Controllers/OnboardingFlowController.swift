import Foundation
import SwiftUI
import Combine

// MARK: - Onboarding Flow Controller
class OnboardingFlowController: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var onboardingData = OnboardingData()
    @Published var isComplete: Bool = false
    
    let totalSteps = 33
    
    // MARK: - Navigation
    func nextStep() {
        guard canProceed() else { return }
        
        if currentStep < totalSteps {
            currentStep += 1
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }
    
    func skipToStep(_ step: Int) {
        guard step > 0 && step <= totalSteps else { return }
        currentStep = step
    }
    
    // MARK: - Validation
    func canProceed() -> Bool {
        return onboardingData.isStepComplete(currentStep)
    }
    
    // MARK: - Progress
    var progress: Double {
        return Double(currentStep) / Double(totalSteps)
    }
    
    // MARK: - Completion
    func completeOnboarding() {
        // Save data to backend/storage
        saveOnboardingData()
        isComplete = true
    }
    
    private func saveOnboardingData() {
        // TODO: Implement backend save
        print("💾 Saving onboarding data...")
        print("Goal: \(onboardingData.goalName)")
        print("Pack: \(onboardingData.packName)")
        print("Members: \(onboardingData.expectedMemberCount)")
        print("Check-in: \(onboardingData.checkInTime)")
    }
    
    // MARK: - Reset
    func reset() {
        currentStep = 1
        onboardingData.reset()
        isComplete = false
    }
}

// MARK: - Onboarding Container View
struct OnboardingFlowView: View {
    @StateObject private var controller = OnboardingFlowController()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if controller.isComplete {
                // Navigate to main app
                Text("Onboarding Complete!")
                    .foregroundColor(.primary)
            } else {
                VStack(spacing: 0) {
                    // Progress indicator
                    ProgressView(value: controller.progress)
                        .tint(.blue)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Step content
                    stepView(for: controller.currentStep)
                        .environmentObject(controller.onboardingData)
                }
            }
        }
    }
    
    @ViewBuilder
    private func stepView(for step: Int) -> some View {
        Group {
            switch step {
            case 1: OnboardingStep1View(onContinue: controller.nextStep)
            case 2: OnboardingStep2View(onContinue: controller.nextStep)
            case 3: OnboardingStep3View(onContinue: controller.nextStep)
            case 4: OnboardingStep4View(onContinue: controller.nextStep)
            case 5: OnboardingStep5View(onContinue: controller.nextStep)
            case 6: OnboardingStep6View(onContinue: controller.nextStep)
            case 7: OnboardingStep7View(onContinue: controller.nextStep)
            case 8: OnboardingStep8View(onContinue: controller.nextStep)
            case 9: OnboardingStep9View(onContinue: { name in 
                controller.onboardingData.goalName = name
                controller.nextStep()
            })
            case 10: OnboardingStep10View(goal: controller.onboardingData.goalName, onContinue: { hour, minute in
                // Convert hour and minute to Date
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: Date())
                components.hour = Int(hour)
                components.minute = Int(minute)
                if let time = calendar.date(from: components) {
                    controller.onboardingData.checkInTime = time
                }
                controller.nextStep()
            })
            case 11: OnboardingStep11View(goal: controller.onboardingData.goalName, onContinue: { _ in
                // Cost is derived property, just move forward
                controller.nextStep()
            })
            case 12: OnboardingStep12View(onContinue: controller.nextStep)
            case 13: OnboardingStep13View(onContinue: controller.nextStep)
            case 14: OnboardingStep14View(commitmentStyle: .constant(""), onContinue: controller.nextStep)
            case 15: OnboardingStep15View(successVision: .constant(""), onContinue: controller.nextStep)
            case 16: OnboardingStep16View(selectedGoal: controller.onboardingData.goalName, selectedWhy: controller.onboardingData.goalDescription, estimatedCost: controller.onboardingData.monthlyCost, onContinue: controller.nextStep)
            case 17: OnboardingStep17View(onContinue: controller.nextStep)
            case 18: OnboardingStep18View(onContinue: controller.nextStep)
            case 19: OnboardingStep19View(onContinue: controller.nextStep)
            case 20: OnboardingStep20View(onContinue: controller.nextStep)
            case 21: OnboardingStep21View(onContinue: controller.nextStep)
            case 22: OnboardingStep22View(onContinue: controller.nextStep)
            case 23: OnboardingStep23View(onContinue: controller.nextStep)
            case 24: OnboardingStep24View(onContinue: controller.nextStep)
            case 25: OnboardingStep25View(onContinue: controller.nextStep)
            case 26: OnboardingStep26View(onContinue: controller.nextStep)
            case 27: OnboardingStep27View(onContinue: controller.nextStep)
            case 28: OnboardingStep28View(onContinue: controller.nextStep)
            case 29: OnboardingStep29View(onContinue: controller.nextStep)
            case 30: OnboardingStep30View(onContinue: controller.nextStep)
            case 31: OnboardingStep31View(onContinue: controller.nextStep)
            case 32: OnboardingStep32View(onContinue: controller.nextStep)
            case 33: OnboardingStep33View(onContinue: controller.nextStep)
            default:
                Text("Invalid step")
                    .foregroundColor(.primary)
            }
        }
        .environmentObject(controller.onboardingData)
    }
}
