import Foundation

struct UserProfile: Codable, Identifiable, Equatable, Sendable {
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

    enum SubscriptionStatus: String, Codable, Sendable {
        case free
        case trial
        case pro
    }
}

struct UserProfileResponse: Codable, Sendable {
    let success: Bool
    let data: UserProfile
}

// MARK: - Mock Profile Extension
extension UserProfile {
    static let mock = UserProfile(
        id: UUID(),
        phoneNumber: "+1234567890",
        email: "jordan.lee@example.com",
        username: "Jordan Lee",
        profilePic: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f3?w=800&q=80",
        bio: "🏋️‍♂️ Fitness enthusiast | 💻 Tech lover | 🎯 Goal crusher",
        subscriptionStatus: .free,
        subscriptionExpiresAt: nil,
        totalXp: 1450,
        currentLevel: 14,
        currentStreak: 7,
        longestStreak: 21,
        totalCheckins: 87,
        totalFinesPaid: 42,
        totalJailsCompleted: 3,
        createdAt: Date(),
        updatedAt: Date()
    )
}
