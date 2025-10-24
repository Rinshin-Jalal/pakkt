import Foundation

struct PackMember: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let role: MemberRole
    let joinDate: Date
    let reputationXp: Int
    let isActive: Bool
    let createdAt: Date?
    let updatedAt: Date?
    let user: MemberUser?

    enum MemberRole: String, Codable {
        case admin
        case member
    }

    struct MemberUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }
}

struct PackMemberResponse: Codable {
    let success: Bool
    let data: [PackMember]
}
