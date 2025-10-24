import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    let id: UUID
    let phoneNumber: String?
    let email: String?
    let username: String
    let profilePic: String?
    let bio: String?
    let subscriptionStatus: SubscriptionStatus
    let subscriptionExpiresAt: Date?
    let totalXp: Int
    let currentLevel: Int
    let currentStreak: Int
    let longestStreak: Int
    let totalCheckins: Int
    let totalFinesPaid: Int
    let totalJailsCompleted: Int
    let createdAt: Date
    let updatedAt: Date

    enum SubscriptionStatus: String, Codable {
        case free
        case trial
        case pro
    }
}

// API Response wrapper
struct UserProfileResponse: Codable {
    let success: Bool
    let data: UserProfile
}
