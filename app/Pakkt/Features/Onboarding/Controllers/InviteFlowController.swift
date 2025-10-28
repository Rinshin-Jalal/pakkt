import Foundation
import SwiftUI
import Combine

// MARK: - Invite Flow Controller
class InviteFlowController: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var inviteData = InviteData()
    @Published var isComplete: Bool = false
    
    let totalSteps = 10
    
    // MARK: - Initialization
    init(inviteCode: String = "") {
        inviteData.inviteCode = inviteCode
        loadInviteDetails()
    }
    
    private func loadInviteDetails() {
        // TODO: Fetch pack details from backend using invite code
        // Mock data for now
        inviteData.packName = "Morning Warriors"
        inviteData.packGoal = "Wake up at 6 AM"
        inviteData.packSchedule = "Daily at 6:00 AM"
        inviteData.packConsequence = "1 hour jail"
        inviteData.existingMembers = ["Alex", "Jordan", "Sam"]
    }
    
    // MARK: - Navigation
    func nextStep() {
        guard canProceed() else { return }
        
        if currentStep < totalSteps {
            currentStep += 1
        } else {
            completeInviteFlow()
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
        return inviteData.isStepComplete(currentStep)
    }
    
    // MARK: - Progress
    var progress: Double {
        return Double(currentStep) / Double(totalSteps)
    }
    
    // MARK: - Completion
    func completeInviteFlow() {
        // Save data and join pack
        joinPack()
        isComplete = true
    }
    
    private func joinPack() {
        // TODO: Implement backend join
        print("🎉 Joining pack...")
        print("Code: \(inviteData.inviteCode)")
        print("Pack: \(inviteData.packName)")
    }
    
    // MARK: - Reset
    func reset() {
        currentStep = 1
        inviteData.reset()
        isComplete = false
    }
}

// MARK: - Invite Flow Container View
struct InviteFlowView: View {
    let inviteCode: String
    @StateObject private var controller: InviteFlowController
    @Environment(\.dismiss) var dismiss
    
    init(inviteCode: String) {
        self.inviteCode = inviteCode
        _controller = StateObject(wrappedValue: InviteFlowController(inviteCode: inviteCode))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if controller.isComplete {
                // Navigate to main app
                Text("Welcome to the Pack!")
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
                }
            }
        }
    }
    
    @ViewBuilder
    private func stepView(for step: Int) -> some View {
        switch step {
        case 1: 
            InviteStep1View(
                packName: controller.inviteData.packName,
                goalName: controller.inviteData.packGoal,
                memberCount: controller.inviteData.existingMembers.count,
                streakDays: 0,
                onJoin: controller.nextStep
            )
        case 2: 
            InviteStep2View(onContinue: controller.nextStep)
        case 3: 
            InviteStep3View(onContinue: controller.nextStep)
        case 4: 
            InviteStep4View(
                goalName: controller.inviteData.packGoal,
                schedule: controller.inviteData.packSchedule,
                consequence: controller.inviteData.packConsequence,
                onSign: controller.nextStep
            )
        case 5:
            InviteStep4_5View(
                packName: controller.inviteData.packName,
                memberSignatures: controller.inviteData.existingMembers.map { name in
                    PackMemberSignature(
                        memberName: name,
                        signatureStyle: "cursive",
                        timestamp: "Signed"
                    )
                },
                onContinue: controller.nextStep
            )
        case 6: 
            InviteStep5View(onComplete: controller.nextStep)
        case 7: 
            InviteStep6View(
                packName: controller.inviteData.packName,
                memberCount: controller.inviteData.existingMembers.count,
                nextCheckInTime: "Tomorrow at 6:00 AM",
                memberNames: controller.inviteData.existingMembers,
                onActivate: controller.nextStep
            )
        case 8: 
            InviteStep7View(onActivate: controller.nextStep)
        case 9: 
            InviteStep8View(onPurchase: {
                controller.inviteData.subscribedToPakkt = true
                controller.nextStep()
            }, onRestore: {
                controller.inviteData.subscribedToPakkt = true
                controller.nextStep()
            })
        case 10: 
            InviteStep9View(onComplete: controller.nextStep)
        default:
            Text("Invalid step")
                .foregroundColor(.primary)
        }
    }
}
