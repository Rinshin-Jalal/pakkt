import Foundation

actor PacksService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List User's Packs

    func listPacks() async throws -> [Pack] {
        let endpoint = PakktEndpoint.listPacks
        let response: PackListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Create Pack

    func createPack(_ request: CreatePackRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.createPack(request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Pack Details

    func getPack(id: UUID) async throws -> Pack {
        let endpoint = PakktEndpoint.getPack(id: id)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Pack

    func updatePack(id: UUID, request: UpdatePackRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.updatePack(id: id, request: request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Dissolve Pack

    func dissolvePack(id: UUID) async throws {
        let endpoint = PakktEndpoint.dissolvePack(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Members

    func getMembers(packId: UUID) async throws -> [PackMember] {
        let endpoint = PakktEndpoint.getPackMembers(packId: packId)
        let response: PackMemberResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func removeMember(packId: UUID, userId: UUID) async throws {
        let endpoint = PakktEndpoint.removePackMember(packId: packId, userId: userId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Invite Codes (Self-Join System)
    
    func createInviteCode(packId: UUID, request: CreateInviteCodeRequest) async throws -> PackInviteCode {
        let endpoint = PakktEndpoint.createInviteCode(packId: packId, request: request)
        let response: InviteCodeResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func listInviteCodes(packId: UUID) async throws -> [PackInviteCode] {
        let endpoint = PakktEndpoint.listInviteCodes(packId: packId)
        let response: InviteCodeListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func validateInviteCode(_ code: String) async throws -> PackInviteCode {
        let endpoint = PakktEndpoint.validateInviteCode(code)
        let response: InviteCodeResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func useInviteCode(_ request: UseInviteCodeRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.useInviteCode(request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func deactivateInviteCode(packId: UUID, codeId: UUID) async throws {
        let endpoint = PakktEndpoint.deactivateInviteCode(packId: packId, codeId: codeId)
        try await apiClient.request(endpoint)
    }

    func deleteInviteCode(packId: UUID, codeId: UUID) async throws {
        let endpoint = PakktEndpoint.deleteInviteCode(packId: packId, codeId: codeId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Stats

    func getStats(packId: UUID) async throws -> PackStats {
        let endpoint = PakktEndpoint.getPackStats(packId: packId)
        let response: PackStatsResponse = try await apiClient.request(endpoint)
        return response.data
    }
}
