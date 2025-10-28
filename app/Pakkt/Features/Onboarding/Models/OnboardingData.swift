import Foundation
import SwiftUI
import Combine

// MARK: - Onboarding Data Model
class OnboardingData: ObservableObject {
    // Step 1-3: Introduction (no data)
    
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
    
    // Step 15: Pack Name & Photo
    @Published var packName: String = ""
    @Published var packPhoto: UIImage?
    
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
        case 1...3: return true
        case 4: return !goalName.isEmpty && !goalDescription.isEmpty
        case 5: return true
        case 6: return true
        case 7: return !selectedApps.isEmpty
        case 8: return true
        case 9: return expectedMemberCount >= minPackSize && expectedMemberCount <= maxPackSize
        case 10: return votingPeriodMinutes > 0
        case 11: return jailTimeMinutes > 0
        case 12...13: return true
        case 14: return userSignature != nil
        case 15: return !packName.isEmpty
        case 16...17: return true
        case 18: return true // Optional to invite
        case 19: return notificationsEnabled
        case 20: return bankConnected
        case 21: return paymentMethodAdded
        case 22: return !profileName.isEmpty
        case 23: return !profileUsername.isEmpty
        case 24: return profilePhoto != nil
        case 25...28: return agreedToStandards
        case 29: return reviewedRules
        case 30...31: return true
        case 32: return subscribedToPakkt
        case 33: return true
        default: return false
        }
    }
    
    // MARK: - Reset
    func reset() {
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
        packPhoto = nil
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
