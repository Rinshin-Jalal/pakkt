import Foundation
import Combine
import SwiftUI

@MainActor
class RealtimeFeedManager: ObservableObject {
    static let shared = RealtimeFeedManager()
    
    @Published var shouldRefreshFeed = false
    private var cancellables = Set<AnyCancellable>()
    private let realtimeService: SupabaseRealtimeService
    
    private var currentSubscriptions: [String] = []
    private var appInBackground = false
    
    init(realtimeService: SupabaseRealtimeService = SupabaseRealtimeService()) {
        self.realtimeService = realtimeService
    }
    
    // MARK: - Subscribe to Pack Feed Updates
    
    func subscribeToPackFeed(packId: String) async {
        // First, unsubscribe from any existing pack feed subscriptions to avoid duplicates
        await unsubscribeFrom(subscriptionId: "pack_feed:\(packId)")
        
        // Store the subscription ID to track active subscriptions
        let subscriptionId = "pack_feed:\(packId)"
        if !currentSubscriptions.contains(subscriptionId) {
            currentSubscriptions.append(subscriptionId)
        }
        
        do {
            try await realtimeService.subscribeToPackFeed(
                packId: packId,
                onInsert: { [weak self] record in
                    print("Received real-time feed update for pack: \(packId), record: \(record)")
                    // Trigger a feed refresh when new content comes in
                    Task { @MainActor in
                        self?.shouldRefreshFeed = true
                    }
                }
            )
            print("Successfully subscribed to pack feed: \(packId)")
        } catch {
            print("Failed to subscribe to pack feed: \(error)")
        }
    }
    
    // MARK: - Subscribe to Individual Check-in Updates
    
    func subscribeToCheckInUpdates(packId: String) async {
        // First, unsubscribe to avoid duplicates
        await unsubscribeFrom(subscriptionId: "check_ins:\(packId)")
        
        let subscriptionId = "check_ins:\(packId)"
        if !currentSubscriptions.contains(subscriptionId) {
            currentSubscriptions.append(subscriptionId)
        }
        
        do {
            try await realtimeService.subscribeToCheckIns(
                packId: packId,
                onInsert: { [weak self] record in
                    print("Received real-time check-in update for pack: \(packId), record: \(record)")
                    Task { @MainActor in
                        self?.shouldRefreshFeed = true
                    }
                }
            )
        } catch {
            print("Failed to subscribe to check-in updates: \(error)")
        }
    }
    
    func subscribeToCommentsUpdates(checkInId: String) async {
        // First, unsubscribe to avoid duplicates
        await unsubscribeFrom(subscriptionId: "comments:\(checkInId)")
        
        let subscriptionId = "comments:\(checkInId)"
        if !currentSubscriptions.contains(subscriptionId) {
            currentSubscriptions.append(subscriptionId)
        }
        
        do {
            try await realtimeService.subscribeToComments(
                checkInId: checkInId,
                onInsert: { [weak self] record in
                    print("Received real-time comment update for check-in: \(checkInId), record: \(record)")
                    // For comments, we might want a more specific event or just refresh
                    Task { @MainActor in
                        self?.shouldRefreshFeed = true
                    }
                }
            )
        } catch {
            print("Failed to subscribe to comments: \(error)")
        }
    }
    
    func subscribeToReactionsUpdates(checkInId: String) async {
        // First, unsubscribe to avoid duplicates
        await unsubscribeFrom(subscriptionId: "reactions:\(checkInId)")
        
        let subscriptionId = "reactions:\(checkInId)"
        if !currentSubscriptions.contains(subscriptionId) {
            currentSubscriptions.append(subscriptionId)
        }
        
        do {
            try await realtimeService.subscribeToReactions(
                checkInId: checkInId,
                onInsert: { [weak self] record in
                    print("Received real-time reaction update for check-in: \(checkInId), record: \(record)")
                    Task { @MainActor in
                        self?.shouldRefreshFeed = true
                    }
                }
            )
        } catch {
            print("Failed to subscribe to reactions: \(error)")
        }
    }
    
    func subscribeToFineVotesUpdates(fineId: String) async {
        // First, unsubscribe to avoid duplicates
        await unsubscribeFrom(subscriptionId: "fine_votes:\(fineId)")
        
        let subscriptionId = "fine_votes:\(fineId)"
        if !currentSubscriptions.contains(subscriptionId) {
            currentSubscriptions.append(subscriptionId)
        }
        
        do {
            try await realtimeService.subscribeToFineVotes(
                fineId: fineId,
                onInsert: { [weak self] record in
                    print("Received real-time fine vote update for fine: \(fineId), record: \(record)")
                    Task { @MainActor in
                        self?.shouldRefreshFeed = true
                    }
                }
            )
        } catch {
            print("Failed to subscribe to fine votes: \(error)")
        }
    }
    
    // MARK: - App Lifecycle Management
    
    func handleAppDidEnterBackground() async {
        print("App entered background, handling real-time connection...")
        appInBackground = true
        // In some implementations, you might want to reduce connection frequency or pause non-critical updates
        await realtimeService.handleAppDidEnterBackground()
    }
    
    func handleAppWillEnterForeground() async {
        print("App will enter foreground, restoring real-time connection...")
        appInBackground = false
        await realtimeService.handleAppWillEnterForeground()
        
        // Potentially refresh data when coming back to foreground
        Task { @MainActor in
            self.shouldRefreshFeed = true
        }
    }
    
    func isAppInBackground() -> Bool {
        return appInBackground
    }
    
    // MARK: - Unsubscribe
    
    func unsubscribeFromAll() async {
        await realtimeService.unsubscribeAll()
        currentSubscriptions.removeAll()
    }
    
    func unsubscribeFrom(subscriptionId: String) async {
        await realtimeService.unsubscribe(from: subscriptionId)
        currentSubscriptions.removeAll { $0 == subscriptionId }
    }
    
    // MARK: - Manual Refresh Trigger
    
    func triggerManualRefresh() {
        Task { @MainActor in
            shouldRefreshFeed = true
        }
    }
}