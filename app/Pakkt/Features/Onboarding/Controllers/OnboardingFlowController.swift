import Foundation
import SwiftUI
import Combine

// MARK: - Onboarding Flow Controller
class OnboardingFlowController: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var onboardingData = OnboardingData()
    @Published var isComplete: Bool = false
    
    let totalSteps = 27  // New 27-step emotional journey flow
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
            // ACT 1: HOOK (Steps 1-2)
            case 1: WelcomeToPacktView(onContinue: controller.nextStep)
            case 2: WhatIsPackView(onContinue: controller.nextStep)
            
            // ACT 2: PAIN (Steps 3-9)
            case 3: GoalFailureInputView(
                onContinue: controller.nextStep,
                goalName: $controller.onboardingData.goalName
            )
            case 4: WhyWillpowerFailsView(onContinue: controller.nextStep)
            case 5: FailurePatternView(
                onContinue: controller.nextStep,
                failureCount: $controller.onboardingData.failureCount
            )
            case 6: FailedApproachesVisualView(onContinue: controller.nextStep)
            case 7: WhatYouveTriedView(
                onContinue: controller.nextStep,
                failedApproaches: $controller.onboardingData.failedApproaches
            )
            case 8: EmotionalImpactView(
                onContinue: controller.nextStep,
                emotionalImpact: $controller.onboardingData.emotionalImpact
            )
            case 9: SuccessVisionView(
                onContinue: controller.nextStep,
                successVision: $controller.onboardingData.successVision
            )
            
            // ACT 3: RELIEF (Steps 10-13)
            case 10: ConsequencesVsWillpowerView(onContinue: controller.nextStep)
            case 11: HowPacktWorksView(onContinue: controller.nextStep)
            case 12: LivePackExampleView(onContinue: controller.nextStep)
            case 13: BrotherhoodFeaturesView(onContinue: controller.nextStep)
            
            // ACT 4: BRIDGE (Step 14)
            case 14: ValuePropositionView(onContinue: controller.nextStep)
            
            // ACT 5: BUILD (Steps 15-23) - Existing pack creation flow
            case 15: PackFoundationView(onContinue: controller.nextStep)
            case 16: PackIdentityView(onContinue: controller.nextStep)
            case 17: GoalsCreationView(onContinue: controller.nextStep)
            case 18: PackRulesView(onContinue: controller.nextStep)
            case 19: PackConsequencesView(onContinue: controller.nextStep)
            case 20: PackPreviewView(onContinue: controller.nextStep)
            case 21: PackPactAgreementView(onContinue: controller.nextStep)
            case 22: SignPackPactView(onContinue: controller.nextStep)
            
            // ACT 6: URGENCY (Step 24)
            case 23: CountdownToFirstChallengeView(
                onContinue: controller.nextStep,
                firstCheckInTime: $controller.onboardingData.firstCheckInTime
            )
            
            // ACT 7: COMMIT (Steps 25-27)
            case 24: PermissionsSetupView(onContinue: controller.nextStep)
            case 25: YourPackRealityView(
                onContinue: controller.nextStep,
                packName: $controller.onboardingData.packName,
                packSize: $controller.onboardingData.packSize,
                goalName: $controller.onboardingData.goalName,
                cashFine: $controller.onboardingData.cashFine,
                jailTimeMinutes: $controller.onboardingData.jailTimeMinutes
            )
            case 26: PaywallView(onContinue: controller.nextStep)
            
            default:
                Text("Invalid step")
                    .foregroundColor(.primary)
            }
        }
        .environmentObject(controller.onboardingData)
    }
}
