import Foundation

actor SocialService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Reactions

    func addReaction(to checkInId: UUID, emoji: EmojiType) async throws {
        let request = CreateReactionRequest(checkInId: checkInId, feedEventId: nil, emoji: emoji)
        let endpoint = PakktEndpoint.createReaction(request)
        try await apiClient.request(endpoint)
    }

    func removeReaction(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteReaction(id: id)
        try await apiClient.request(endpoint)
    }

    func getReactions(checkInId: UUID) async throws -> [Reaction] {
        let endpoint = PakktEndpoint.getReactions(checkInId: checkInId)
        let response: ReactionsResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Comments

    func addComment(to checkInId: UUID, content: String) async throws {
        let request = CreateCommentRequest(checkInId: checkInId, content: content)
        let endpoint = PakktEndpoint.createComment(request)
        try await apiClient.request(endpoint)
    }

    func editComment(id: UUID, content: String) async throws {
        let request = EditCommentRequest(content: content)
        let endpoint = PakktEndpoint.editComment(id: id, request: request)
        try await apiClient.request(endpoint)
    }

    func deleteComment(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteComment(id: id)
        try await apiClient.request(endpoint)
    }

    func getComments(checkInId: UUID) async throws -> [Comment] {
        let endpoint = PakktEndpoint.getComments(checkInId: checkInId)
        let response: CommentsResponse = try await apiClient.request(endpoint)
        return response.data
    }
}
