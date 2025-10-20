import Foundation

struct Profile: Codable {
    let userId: String
    let username: String?
    let displayName: String?
    let bio: String?
    let avatarUrl: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case displayName = "display_name"
        case bio
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
    }
}

@MainActor
class ProfileViewModel: BaseViewModel {
    @Published var profile: Profile?

    func loadProfile(userId: String) async {
        do {
            let profiles: [Profile] = try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.getProfile(userId: userId))
            }
            self.profile = profiles.first
        } catch {
            handleError(error)
        }
    }

    func updateProfile(username: String?, displayName: String?, bio: String?) async {
        do {
            let profileData: [String: Any] = [
                "username": username ?? "",
                "display_name": displayName ?? "",
                "bio": bio ?? ""
            ]

            guard let data = try? JSONSerialization.data(withJSONObject: profileData) else {
                throw APIError.invalidURL
            }

            try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.updateProfile(data: data))
            }

            // Reload profile after update
            if let userId = profile?.userId {
                await loadProfile(userId: userId)
            }
        } catch {
            handleError(error)
        }
    }
}
