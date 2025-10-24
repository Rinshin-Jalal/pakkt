// app/Pakkt/Features/Jail/Services/JailService.swift
import Foundation

actor JailService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Start Jail

    func startJail(request: StartJailRequest) async throws -> JailSession {
        let endpoint = PakktEndpoint.startJail(request)
        let response: JailSessionResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Active Session

    func getActiveSession() async throws -> JailSessionWithProgress? {
        let endpoint = PakktEndpoint.getActiveJailSession
        do {
            let response: JailSessionWithProgressResponse = try await apiClient.request(endpoint)
            return response.data
        } catch APIError.notFound {
            return nil
        }
    }

    // MARK: - Send Heartbeat

    func sendHeartbeat(sessionId: UUID) async throws {
        let endpoint = PakktEndpoint.jailHeartbeat(sessionId: sessionId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Complete Jail

    func completeJail(sessionId: UUID) async throws {
        let endpoint = PakktEndpoint.completeJail(sessionId: sessionId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Break Jail

    func breakJail(sessionId: UUID, paymentMethod: String? = nil) async throws {
        let request = BreakJailRequest(paymentMethod: paymentMethod)
        let endpoint = PakktEndpoint.breakJail(sessionId: sessionId, request: request)
        try await apiClient.request(endpoint)
    }
}

struct BreakJailRequest: Codable {
    let paymentMethod: String?
}