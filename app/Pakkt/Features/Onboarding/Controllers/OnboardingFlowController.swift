import Foundation
import SwiftUI
import Combine

// MARK: - Onboarding Flow Controller
class OnboardingFlowController: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var onboardingData = OnboardingData()
    @Published var isComplete: Bool = false
    
    let totalSteps = 33
    var onComplete: (() -> Void)?
    
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
    
    // MARK: - Invite Code Handling
    func handleInviteCode(_ code: String) {
        // TODO: Navigate to invite flow instead of regular onboarding
        // For now, just store it and continue
        print("📨 Invite code entered: \(code)")
        // This should transition to InviteFlowController
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
        onComplete?()
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
    @StateObject private var controller: OnboardingFlowController
    @Environment(\.dismiss) var dismiss
    
    init(onComplete: @escaping () -> Void) {
        _controller = StateObject(wrappedValue: {
            let ctrl = OnboardingFlowController()
            ctrl.onComplete = onComplete
            return ctrl
        }())
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if controller.isComplete {
                // Navigate to main app
                Text("Onboarding Complete!")
                    .foregroundColor(.primary)
            } else {
                // Step content
                stepView(for: controller.currentStep)
                    .environmentObject(controller.onboardingData)
            }
        }
    }
    
            @ViewBuilder
    private func stepView(for step: Int) -> some View {
        Group {
            switch step {
            // Phase 1: QUESTIONS (Steps 1-12) - Get personal investment FIRST
            case 1: OnboardingStep1View(
                onContinue: controller.nextStep,
                onInviteCode: controller.handleInviteCode
            )
            case 2: OnboardingStep2View(onContinue: controller.nextStep)
            case 3: OnboardingStep3View(onContinue: controller.nextStep)
            case 4: OnboardingStep4View(onContinue: controller.nextStep)
            // Personal questions moved from steps 9-16
            case 5: OnboardingStep9View(onContinue: { name in 
                controller.onboardingData.goalName = name
                controller.nextStep()
            })
            case 6: OnboardingStep10View(goal: controller.onboardingData.goalName, onContinue: { hour, minute in
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day], from: Date())
                components.hour = Int(hour)
                components.minute = Int(minute)
                if let time = calendar.date(from: components) {
                    controller.onboardingData.checkInTime = time
                }
                controller.nextStep()
            })
            case 7: OnboardingStep11View(goal: controller.onboardingData.goalName, onContinue: { _ in
                controller.nextStep()
            })
            case 8: OnboardingStep12View(onContinue: controller.nextStep)
            case 9: OnboardingStep13View(onContinue: controller.nextStep)
            case 10: OnboardingStep14View(commitmentStyle: .constant(""), onContinue: controller.nextStep)
            case 11: OnboardingStep15View(successVision: .constant(""), onContinue: controller.nextStep)
            case 12: OnboardingStep16View(selectedGoal: controller.onboardingData.goalName, selectedWhy: controller.onboardingData.goalDescription, estimatedCost: controller.onboardingData.monthlyCost, onContinue: controller.nextStep)
            
            // Phase 2: INFO (Steps 13-17) - Show them WHY Pakkt works
            case 13: OnboardingStep32View(onContinue: controller.nextStep) // Value prop moved from step 32
            case 14: OnboardingStep29View(onContinue: controller.nextStep) // Live feed moved from step 29
            case 15: OnboardingStep30View(onContinue: controller.nextStep) // Phone jail demo moved from step 30
            case 16: OnboardingStep31View(onContinue: controller.nextStep) // First check-in moved from step 31
            case 17: OnboardingStep17View(onContinue: controller.nextStep) // NEW: Success stories
            
            // Phase 3: QUESTIONS (Steps 18-27) - Create pack with full understanding
            case 18: OnboardingStep5View(onContinue: controller.nextStep) // Pack definition moved from step 5
            case 19: OnboardingStep6View(onContinue: controller.nextStep) // Consequences moved from step 6
            case 20: OnboardingStep17View(onContinue: controller.nextStep) // Pack foundation moved from step 17
            case 21: OnboardingStep18View(onContinue: controller.nextStep) // Member invitation moved from step 18
            case 22: OnboardingStep19View(onContinue: controller.nextStep) // Consequence setup moved from step 19
            case 23: OnboardingStep20View(onContinue: controller.nextStep) // Pack rules moved from step 20
            case 24: OnboardingStep21View(onContinue: controller.nextStep) // Goal config moved from step 21
            case 25: OnboardingStep24View(onContinue: controller.nextStep) // Pack agreement moved from step 24
            case 26: OnboardingStep25View(onContinue: controller.nextStep) // Signature moved from step 25
            case 27: OnboardingStep26View(onContinue: controller.nextStep) // Pack seal moved from step 26
            
            // Phase 4: INFO (Steps 28-31) - Social proof reinforcement
            case 28: OnboardingStep7View(onContinue: controller.nextStep) // Pack examples moved from step 7
            case 29: OnboardingStep8View(onContinue: controller.nextStep) // Brotherhood moved from step 8
            case 30: OnboardingStep27View(onContinue: controller.nextStep) // Screen time setup moved from step 27
            case 31: OnboardingStep28View(onContinue: controller.nextStep) // Notifications moved from step 28
            
            // Phase 5: PAYWALL (Steps 32-33) - They're ready to pay
            case 32: OnboardingStep33View(onContinue: controller.nextStep) // Enhanced paywall
            case 33: OnboardingStep33View(onContinue: controller.nextStep) // Final success
            default:
                Text("Invalid step")
                    .foregroundColor(.primary)
            }
        }
        .environmentObject(controller.onboardingData)
    }
}
