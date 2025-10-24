import Foundation

enum EmojiType: String, Codable, CaseIterable {
    case fire = "🔥"
    case muscle = "💪"
    case clap = "👏"
    case party = "🎉"
    case laugh = "😂"
    case heart = "❤️"
    case eyes = "👀"
}

struct Reaction: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let userId: UUID
    let checkInId: UUID?
    let feedEventId: UUID?
    let emoji: EmojiType
    let createdAt: Date
    let user: ReactionUser?

    struct ReactionUser: Codable, Equatable, Sendable {
        let username: String
        let profilePic: String?
    }
}

struct ReactionCounts: Codable, Equatable, Sendable {
    var counts: [String: ReactionCount]

    struct ReactionCount: Codable, Equatable, Sendable {
        let count: Int
        let users: [UUID]
        let userReacted: Bool
    }
}

struct ReactionsResponse: Codable, Sendable {
    let success: Bool
    let data: [Reaction]
}
