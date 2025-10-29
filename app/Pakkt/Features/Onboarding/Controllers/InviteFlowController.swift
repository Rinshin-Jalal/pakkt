import Foundation
import SwiftUI
import Combine

// MARK: - Invite Flow Controller
@MainActor
class InviteFlowController: ObservableObject {
    @Published var currentStep: Int = 1
    @Published var inviteData = InviteData()
    @Published var isComplete: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let packsService: PacksService
    let totalSteps = 10
    
    // MARK: - Initialization
    init(inviteCode: String = "", packsService: PacksService = PacksService()) {
        self.packsService = packsService
        inviteData.inviteCode = inviteCode
        
        if !inviteCode.isEmpty {
            Task {
                await loadInviteDetails()
            }
        }
    }
    
    func loadInviteDetails() async {
        guard !inviteData.inviteCode.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Validate invite code and get pack details
            let inviteCode = try await packsService.validateInviteCode(inviteData.inviteCode)
            let pack = try await packsService.getPack(id: inviteCode.packId)
            let members = try await packsService.getMembers(packId: inviteCode.packId)
            
            // Update invite data with real info
            inviteData.packName = pack.name
            inviteData.existingMembers = members.compactMap { $0.user?.username }
            
            // TODO: Get goal and schedule from pack
            // inviteData.packGoal = pack.primaryGoal?.title ?? "Team Goal"
            // inviteData.packSchedule = pack.primaryGoal?.checkInTime ?? "Daily"
            
            print("✅ Loaded invite details for pack: \(pack.name)")
        } catch {
            errorMessage = "Invalid or expired invite code"
            print("❌ Failed to load invite details: \(error)")
        }
    }
    
    // MARK: - Navigation
    func nextStep() {
        guard canProceed() else { return }
        
        if currentStep < totalSteps {
            currentStep += 1
        } else {
            Task {
                await completeInviteFlow()
            }
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
    func completeInviteFlow() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Join pack using invite code
            let request = UseInviteCodeRequest(code: inviteData.inviteCode)
            let pack = try await packsService.useInviteCode(request)
            
            print("🎉 Successfully joined pack: \(pack.name)")
            isComplete = true
        } catch {
            errorMessage = "Failed to join pack. Please try again."
            print("❌ Failed to join pack: \(error)")
        }
    }
    
    // MARK: - Reset
    func reset() {
        currentStep = 1
        inviteData.reset()
        isComplete = false
        errorMessage = nil
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
