import Foundation
import SwiftUI
import Combine

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
    @Published var packIds: [String] = [] // Track packs the user is in
    
    private let realtimeFeedManager: RealtimeFeedManager
    
    init(realtimeFeedManager: RealtimeFeedManager = RealtimeFeedManager.shared) {
        self.realtimeFeedManager = realtimeFeedManager
        super.init()
        
        // Listen for real-time feed updates and refresh when needed
        Task {
            await setupRealtimeSubscriptions()
        }
    }
    
    private func setupRealtimeSubscriptions() async {
        // Monitor the realtime manager for updates
        Task {
            var lastRefreshTime = Date().timeIntervalSince1970
            while true {
                if await realtimeFeedManager.shouldRefreshFeed {
                    let now = Date().timeIntervalSince1970
                    // Avoid rapid refreshes - wait at least 0.5 seconds between refreshes
                    if now - lastRefreshTime > 0.5 {
                        await refreshFeed()
                        lastRefreshTime = now
                        // Reset the flag after processing
                        await realtimeFeedManager.resetRefreshFlag()
                    }
                }
                try? await Task.sleep(nanoseconds: 200_000_000) // Sleep 0.2 seconds to check for updates
            }
        }
    }
    
    // Method to join a pack and start subscribing to its updates
    func joinPack(packId: String) {
        if !packIds.contains(packId) {
            packIds.append(packId)
            Task {
                await realtimeFeedManager.subscribeToPackFeed(packId: packId)
            }
        }
    }
    
    // Method to leave a pack and stop subscribing to its updates
    func leavePack(packId: String) {
        packIds.removeAll { $0 == packId }
        Task {
            await realtimeFeedManager.unsubscribeFrom(subscriptionId: "pack_feed:\(packId)")
        }
    }

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

// Extension to add the resetRefreshFlag method
extension RealtimeFeedManager {
    func resetRefreshFlag() async {
        await MainActor.run {
            shouldRefreshFeed = false
        }
    }
}
