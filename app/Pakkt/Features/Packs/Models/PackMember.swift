import Foundation

struct PackMember: Codable, Identifiable, Equatable, Sendable {
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

    enum MemberRole: String, Codable, Sendable {
        case admin
        case member
    }

    struct MemberUser: Codable, Equatable, Sendable {
        let username: String
        let profilePic: String?
    }
    
    // Convenience properties
    var username: String {
        user?.username ?? "Unknown"
    }
    
    var isAdmin: Bool {
        role == .admin
    }
}

struct PackMemberResponse: Codable, Sendable {
    let success: Bool
    let data: [PackMember]
}
