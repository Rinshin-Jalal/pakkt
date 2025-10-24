// app/Pakkt/Features/Fines/Services/FinesService.swift
import Foundation

actor FinesService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List Fines

    func listPackFines(packId: UUID) async throws -> [Fine] {
        let endpoint = PakktEndpoint.listPackFines(packId: packId)
        let response: FineListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Fine with Votes

    func getFineWithVotes(id: UUID) async throws -> FineWithVotes {
        let endpoint = PakktEndpoint.getFine(id: id)
        let response: FineWithVotesResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Vote on Fine

    func vote(on fineId: UUID, enforce: Bool, comment: String? = nil) async throws {
        let request = VoteRequest(vote: enforce, comment: comment)
        let endpoint = PakktEndpoint.voteOnFine(fineId: fineId, request: request)
        try await apiClient.request(endpoint)
    }

    // MARK: - Resolve Fine (Manual)

    func resolveFine(id: UUID) async throws {
        let endpoint = PakktEndpoint.resolveFine(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Appeal Fine

    func appealFine(id: UUID, reason: String) async throws {
        let request = AppealRequest(reason: reason)
        let endpoint = PakktEndpoint.appealFine(id: id, request: request)
        try await apiClient.request(endpoint)
    }
}

struct AppealRequest: Codable {
    let reason: String
}
