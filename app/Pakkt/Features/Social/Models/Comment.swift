import Foundation

struct Comment: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let checkInId: UUID
    let userId: UUID
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let user: CommentUser?

    struct CommentUser: Codable, Equatable, Sendable {
        let username: String
        let profilePic: String?
    }
}

struct CommentsResponse: Codable, Sendable {
    let success: Bool
    let data: [Comment]
}
