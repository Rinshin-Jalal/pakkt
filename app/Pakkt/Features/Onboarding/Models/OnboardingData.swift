import Foundation
import SwiftUI
import Combine

// MARK: - Onboarding Data Model
class OnboardingData: ObservableObject {
    // Step 1-3: Introduction (no data)
    
    // New Flow: Steps 1-14 (Pre-Pack Creation)
    @Published var failureCount: Int = 15
    @Published var failedApproaches: [String] = []
    @Published var emotionalImpact: String = ""
    @Published var successVision: String = ""
    @Published var firstCheckInTime: Date = Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
    
    // Step 4: Goal Setting
    @Published var goalName: String = ""
    @Published var goalDescription: String = ""
    
    // Step 5-6: Check-in Time
    @Published var checkInTime: Date = Date()
    @Published var checkInWindowMinutes: Int = 30
    
    // Step 7: Distracting Apps
    @Published var selectedApps: [String] = []
    
    // Step 8-9: Pack Size & Member Count
    @Published var minPackSize: Int = 2
    @Published var maxPackSize: Int = 6
    @Published var expectedMemberCount: Int = 3
    
    // Step 10: Voting Period
    @Published var votingPeriodMinutes: Int = 5
    
    // Step 11: Jail Time
    @Published var jailTimeMinutes: Int = 60
    
    // Step 12-13: Cost Calculation (derived values)
    var monthlyCost: Double {
        let baseCost = 16.0 // $4/week * 4 weeks
        return baseCost
    }
    
    // Step 14: Signature
    @Published var userSignature: UIImage?
    
    // Step 17: Pack Foundation
    @Published var packName: String = ""
    @Published var packSize: Int = 5
    @Published var packPhoto: UIImage?

    // Step 18: Pack Identity
    @Published var packSymbol: String = "pawprint.fill"
    @Published var packColor: String = "blue"
    @Published var packMotto: String = "Together We Rise"

    // Step 19: Goals Creation
    @Published var goalTime: Date = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var goalActiveDays: Set<Int> = [1, 2, 3, 4, 5] // Mon-Fri
    @Published var goalFrequency: String = "Daily"

    // Step 20: Pack Rules
    @Published var photoProofRequired: Bool = true
    @Published var checkInWindowBefore: Int = 0
    @Published var checkInWindowAfter: Int = 15
    @Published var weekendPassesEnabled: Bool = false
    @Published var gracePeriodMinutes: Int = 0

    // Step 21: Pack Consequences
    @Published var cashFine: Double = 5.0
    @Published var requireMajorityVote: Bool = true
    
    // Step 16-17: Privacy Settings
    @Published var packVisibility: String = "private"
    @Published var allowInvites: Bool = true
    @Published var allowJoinRequests: Bool = false
    
    // Step 18: Pack Invitation
    @Published var invitedMembers: [String] = []
    
    // Step 19: Phone Permissions
    @Published var notificationsEnabled: Bool = false
    @Published var locationEnabled: Bool = false
    @Published var cameraEnabled: Bool = false
    @Published var screenTimeEnabled: Bool = false
    
    // Step 20-21: Bank & Payment
    @Published var bankConnected: Bool = false
    @Published var paymentMethodAdded: Bool = false
    
    // Step 22-24: Profile Setup
    @Published var profileName: String = ""
    @Published var profileUsername: String = ""
    @Published var profilePhoto: UIImage?
    
    // Step 25-28: Community Standards
    @Published var agreedToStandards: Bool = false
    
    // Step 29: Pack Rules Preview
    @Published var reviewedRules: Bool = false
    
    // Step 30-31: Streak Info & Final Prep (no data)
    
    // Step 32-33: Subscription & Success
    @Published var subscribedToPakkt: Bool = false
    
    // MARK: - Validation
    func isStepComplete(_ step: Int) -> Bool {
        switch step {
        case 1...33: return true // Simplified - allow all steps to proceed
        default: return false
        }
    }
    
    // MARK: - Reset
    func reset() {
        failureCount = 15
        failedApproaches = []
        emotionalImpact = ""
        successVision = ""
        firstCheckInTime = Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
        goalName = ""
        goalDescription = ""
        checkInTime = Date()
        checkInWindowMinutes = 30
        selectedApps = []
        minPackSize = 2
        maxPackSize = 6
        expectedMemberCount = 3
        votingPeriodMinutes = 5
        jailTimeMinutes = 60
        userSignature = nil
        packName = ""
        packSize = 5
        packPhoto = nil
        packSymbol = "pawprint.fill"
        packColor = "blue"
        packMotto = "Together We Rise"
        goalTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date()) ?? Date()
        goalActiveDays = [1, 2, 3, 4, 5]
        goalFrequency = "Daily"
        photoProofRequired = true
        checkInWindowBefore = 0
        checkInWindowAfter = 15
        weekendPassesEnabled = false
        gracePeriodMinutes = 0
        cashFine = 5.0
        requireMajorityVote = true
        packVisibility = "private"
        allowInvites = true
        allowJoinRequests = false
        invitedMembers = []
        notificationsEnabled = false
        locationEnabled = false
        cameraEnabled = false
        screenTimeEnabled = false
        bankConnected = false
        paymentMethodAdded = false
        profileName = ""
        profileUsername = ""
        profilePhoto = nil
        agreedToStandards = false
        reviewedRules = false
        subscribedToPakkt = false
    }
}

// MARK: - Invite Data Model
class InviteData: ObservableObject {
    // Invite context
    @Published var inviteCode: String = ""
    @Published var packName: String = ""
    @Published var packGoal: String = ""
    @Published var packSchedule: String = ""
    @Published var packConsequence: String = ""
    @Published var existingMembers: [String] = []
    
    // Step 5: Signature
    @Published var userSignature: UIImage?
    
    // Step 6-7: Value & Subscription
    @Published var subscribedToPakkt: Bool = false
    
    // Step 8: Permissions
    @Published var notificationsEnabled: Bool = false
    @Published var locationEnabled: Bool = false
    @Published var cameraEnabled: Bool = false
    @Published var screenTimeEnabled: Bool = false
    
    // Step 9: Profile
    @Published var profilePhoto: UIImage?
    
    // MARK: - Validation
    func isStepComplete(_ step: Int) -> Bool {
        switch step {
        case 1...4: return true
        case 5: return userSignature != nil
        case 6...7: return subscribedToPakkt
        case 8: return notificationsEnabled
        case 9: return profilePhoto != nil
        default: return false
        }
    }
    
    // MARK: - Reset
    func reset() {
        inviteCode = ""
        packName = ""
        packGoal = ""
        packSchedule = ""
        packConsequence = ""
        existingMembers = []
        userSignature = nil
        subscribedToPakkt = false
        notificationsEnabled = false
        locationEnabled = false
        cameraEnabled = false
        screenTimeEnabled = false
        profilePhoto = nil
    }
}
