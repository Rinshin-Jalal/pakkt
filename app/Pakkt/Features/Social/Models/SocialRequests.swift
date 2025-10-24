import Foundation

struct CreateReactionRequest: Codable, Sendable {
    let checkInId: UUID?
    let feedEventId: UUID?
    let emoji: EmojiType
}

struct CreateCommentRequest: Codable, Sendable {
    let checkInId: UUID
    let content: String
}

struct EditCommentRequest: Codable, Sendable {
    let content: String
}
