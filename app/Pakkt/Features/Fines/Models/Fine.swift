// app/Pakkt/Features/Fines/Models/Fine.swift
import Foundation

enum FineStatus: String, Codable {
    case pending
    case voting
    case enforced
    case cancelled
    case appealed
}

struct Fine: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let goalId: UUID
    let checkInId: UUID?
    let amount: Int // In cents
    let reason: String
    let status: FineStatus
    let votingEndsAt: Date?
    let resolvedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let user: FineUser?
    let goal: FineGoal?

    struct FineUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }

    struct FineGoal: Codable, Equatable {
        let title: String
    }
}

struct FineResponse: Codable {
    let success: Bool
    let data: Fine
}

struct FineListResponse: Codable {
    let success: Bool
    let data: [Fine]
}
