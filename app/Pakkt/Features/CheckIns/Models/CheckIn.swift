import Foundation

enum CheckInStatus: String, Codable, Sendable {
    case pending
    case verified
    case late
    case missed
}

struct CheckIn: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let goalId: UUID
    let userId: UUID
    let packId: UUID
    let proofUrl: String?
    let caption: String?
    let status: CheckInStatus
    let streakCount: Int
    let xpAwarded: Int
    let checkedInAt: Date
    let createdAt: Date
    let goal: CheckInGoal?
    let user: CheckInUser?

    struct CheckInGoal: Codable, Equatable, Sendable {
        let title: String
        let baseXp: Int
    }

    struct CheckInUser: Codable, Equatable, Sendable {
        let username: String
        let profilePic: String?
    }
}

struct FeedItem: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let goalId: UUID
    let userId: UUID
    let packId: UUID
    let proofUrl: String?
    let caption: String?
    let status: CheckInStatus
    let streakCount: Int
    let xpAwarded: Int
    let checkedInAt: Date
    let createdAt: Date
    let goal: CheckIn.CheckInGoal?
    let user: CheckIn.CheckInUser?
    let reactionsCount: Int?
    let commentsCount: Int?
}

struct CheckInResponse: Codable, Sendable {
    let success: Bool
    let data: CheckIn
}

struct FeedResponse: Codable, Sendable {
    let success: Bool
    let data: [FeedItem]
}
