import Foundation

struct FeedPost: Identifiable, Codable {
    let id: String
    let userId: String
    let content: String
    let createdAt: String
    let likesCount: Int
    let commentsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case content
        case createdAt = "created_at"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
    }
}

@MainActor
class FeedViewModel: BaseViewModel {
    @Published var posts: [FeedPost] = []
    @Published var isRefreshing = false

    func loadFeed() async {
        do {
            let posts: [FeedPost] = try await withLoading {
                try await APIClient.shared.request(PakktEndpoint.getFeed)
            }
            self.posts = posts
        } catch {
            handleError(error)
        }
    }

    func refreshFeed() async {
        isRefreshing = true
        defer { isRefreshing = false }

        await loadFeed()
    }

    func likePost(_ postId: String) async {
        // TODO: Implement like endpoint
        print("Liking post: \(postId)")
    }

    func deletePost(_ postId: String) async {
        // TODO: Implement delete endpoint
        posts.removeAll { $0.id == postId }
    }
}
