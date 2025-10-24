import Foundation

struct PackInviteCode: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let packId: UUID
    let code: String
    let createdBy: UUID
    let maxUses: Int
    let currentUses: Int
    let expiresAt: Date
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
}

struct CreateInviteCodeRequest: Codable, Sendable {
    let maxUses: Int?
    let expiresInHours: Int?

    init(maxUses: Int = 10, expiresInHours: Int = 24) {
        self.maxUses = maxUses
        self.expiresInHours = expiresInHours
    }
}

struct UseInviteCodeRequest: Codable, Sendable {
    let code: String
}

struct InviteCodeResponse: Codable, Sendable {
    let success: Bool
    let data: PackInviteCode
}

struct InviteCodeListResponse: Codable, Sendable {
    let success: Bool
    let data: [PackInviteCode]
}
