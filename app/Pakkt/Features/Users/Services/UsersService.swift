import Foundation

actor UsersService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Get Profile

    func getProfile() async throws -> UserProfile {
        let endpoint = PakktEndpoint.getProfile
        let response: UserProfileResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Profile

    func updateProfile(_ request: UpdateProfileRequest) async throws -> UserProfile {
        let endpoint = PakktEndpoint.updateProfile(request)
        let response: UserProfileResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Register Push Token

    func registerPushToken(token: String, deviceType: String = "ios", deviceId: String? = nil) async throws {
        let request = PushTokenRequest(token: token, deviceType: deviceType, deviceId: deviceId)
        let endpoint = PakktEndpoint.registerPushToken(request)
        try await apiClient.request(endpoint)
    }

    // MARK: - Delete Push Token

    func deletePushToken() async throws {
        let endpoint = PakktEndpoint.deletePushToken
        try await apiClient.request(endpoint)
    }
}

// MARK: - Push Token Request

struct PushTokenRequest: Codable {
    let token: String
    let deviceType: String
    let deviceId: String?
}
