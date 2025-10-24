// app/Pakkt/Features/Fines/Models/FineVote.swift
import Foundation

struct FineVote: Codable, Identifiable, Equatable {
    let id: UUID
    let fineId: UUID
    let userId: UUID
    let vote: Bool // true = enforce, false = dismiss
    let comment: String?
    let createdAt: Date
    let user: VoteUser?

    struct VoteUser: Codable, Equatable {
        let username: String
    }
}

struct VoteResult: Codable, Equatable {
    let fineId: UUID
    let totalVotes: Int
    let enforceVotes: Int
    let dismissVotes: Int
    let consensus: Consensus
    let votingClosed: Bool
    let votes: [FineVote]

    enum Consensus: String, Codable {
        case enforce
        case dismiss
        case pending
    }
}

struct FineWithVotes: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let goalId: UUID
    let checkInId: UUID?
    let amount: Int
    let reason: String
    let status: FineStatus
    let votingEndsAt: Date?
    let resolvedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let voteResult: VoteResult
}

struct VoteRequest: Codable {
    let vote: Bool
    let comment: String?
}

struct FineWithVotesResponse: Codable {
    let success: Bool
    let data: FineWithVotes
}
