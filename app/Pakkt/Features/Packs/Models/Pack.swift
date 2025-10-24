import Foundation

struct Pack: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let creatorId: UUID
    let xp: Int
    let level: Int
    let goalType: String?
    let status: PackStatus
    let createdAt: Date
    let updatedAt: Date?
    let lastActivity: Date?

    enum PackStatus: String, Codable, Sendable {
        case active
        case dissolved
    }
}

struct PackResponse: Codable, Sendable {
    let success: Bool
    let data: Pack
}

struct PackListResponse: Codable, Sendable {
    let success: Bool
    let data: [Pack]
}
