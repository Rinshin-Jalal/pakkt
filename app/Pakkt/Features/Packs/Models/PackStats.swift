import Foundation

struct PackStats: Codable, Equatable, Sendable {
    let packId: UUID
    let totalXp: Int
    let currentLevel: Int
    let memberCount: Int
    let totalCheckins: Int
    let totalFines: Int
    let totalJails: Int
    let averageStreak: Double
    let topPerformers: [TopPerformer]

    struct TopPerformer: Codable, Equatable, Sendable {
        let userId: UUID
        let username: String
        let xp: Int
        let streak: Int
    }
}

struct PackStatsResponse: Codable, Sendable {
    let success: Bool
    let data: PackStats
}
