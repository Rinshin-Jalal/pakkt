import Foundation

struct UpdateProfileRequest: Codable {
    let username: String?
    let profilePic: String?
    let bio: String?

    init(username: String? = nil, profilePic: String? = nil, bio: String? = nil) {
        self.username = username
        self.profilePic = profilePic
        self.bio = bio
    }
}
