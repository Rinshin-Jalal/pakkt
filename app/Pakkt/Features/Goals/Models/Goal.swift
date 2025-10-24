import Foundation

struct Goal: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let title: String
    let description: String?
    let checkInTime: String // HH:MM format
    let recurrenceRule: RecurrenceRule
    let fineAmount: Int // In cents
    let jailDuration: Int // In minutes
    let proofRequired: Bool
    let isActive: Bool
    let baseXp: Int
    let createdAt: Date
    let updatedAt: Date
    let user: GoalUser?

    struct GoalUser: Codable, Equatable, Sendable {
        let username: String
        let profilePic: String?
    }

    // Helper to get check-in time as Date components
    var checkInTimeComponents: DateComponents? {
        let parts = checkInTime.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }
        return DateComponents(hour: hour, minute: minute)
    }
}

struct GoalWithStats: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let title: String
    let description: String?
    let checkInTime: String
    let recurrenceRule: RecurrenceRule
    let fineAmount: Int
    let jailDuration: Int
    let proofRequired: Bool
    let isActive: Bool
    let baseXp: Int
    let createdAt: Date
    let updatedAt: Date
    let totalCheckins: Int
    let completionRate: Double
    let currentStreak: Int
    let longestStreak: Int
}

struct GoalResponse: Codable, Sendable {
    let success: Bool
    let data: Goal
}

struct GoalListResponse: Codable, Sendable {
    let success: Bool
    let data: [Goal]
}
