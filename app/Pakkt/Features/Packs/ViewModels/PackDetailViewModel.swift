import Foundation
import SwiftUI
import Combine

@MainActor
class PackDetailViewModel: BaseViewModel {
    @Published var pack: Pack?
    @Published var members: [PackMember] = []
    @Published var stats: PackStats?
    @Published var checkIns: [CheckIn] = []

    private let packsService: PacksService
    private let checkInsService: CheckInsService
    private let realtimeFeedManager: RealtimeFeedManager
    
    var packId: String = ""
    
    init(
        packsService: PacksService = PacksService(),
        checkInsService: CheckInsService = CheckInsService(),
        realtimeFeedManager: RealtimeFeedManager = RealtimeFeedManager.shared
    ) {
        self.packsService = packsService
        self.checkInsService = checkInsService
        self.realtimeFeedManager = realtimeFeedManager
        super.init()
    }
    
    func loadPackDetail() async {
        guard let uuid = UUID(uuidString: packId) else {
            handleError(NSError(domain: "PackDetailViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid pack ID"]))
            return
        }
        
        do {
            let (pack, members, stats) = try await withLoading {
                async let packFetch = self.packsService.getPack(id: uuid)
                async let membersFetch = self.packsService.getMembers(packId: uuid)
                async let statsFetch = self.packsService.getStats(packId: uuid)
                
                return try await (packFetch, membersFetch, statsFetch)
            }
            
            self.pack = pack
            self.members = members
            self.stats = stats

            // Start listening for check-in updates for this pack
            await startRealtimeCheckInUpdates()
        } catch {
            handleError(error)
        }
    }

    func loadCheckIns() async {
        guard let uuid = UUID(uuidString: packId) else { return }
        
        do {
            let checkIns = try await withLoading {
                try await self.checkInsService.getPackCheckIns(packId: uuid)
            }
            self.checkIns = checkIns
        } catch {
            handleError(error)
        }
    }
    
    func removeMember(userId: UUID) async -> Bool {
        guard let uuid = UUID(uuidString: packId) else { return false }
        
        do {
            try await withLoading {
                try await self.packsService.removeMember(packId: uuid, userId: userId)
            }
            // Reload members after removal
            await loadMembers()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    private func loadMembers() async {
        guard let uuid = UUID(uuidString: packId) else { return }
        
        do {
            let members = try await packsService.getMembers(packId: uuid)
            self.members = members
        } catch {
            handleError(error)
        }
    }
    
    private func startRealtimeCheckInUpdates() async {
        // Subscribe to check-in updates for this pack
        await realtimeFeedManager.subscribeToPackFeed(packId: packId)
        
        // Monitor for updates
        Task {
            var lastRefreshTime = Date().timeIntervalSince1970
            while true {
                if await realtimeFeedManager.shouldRefreshFeed {
                    let now = Date().timeIntervalSince1970
                    // Avoid rapid refreshes - wait at least 0.5 seconds between refreshes
                    if now - lastRefreshTime > 0.5 {
                        await refreshCheckIns()
                        lastRefreshTime = now
                        // Reset the flag after processing
                        await realtimeFeedManager.resetRefreshFlag()
                    }
                }
                try? await Task.sleep(nanoseconds: 200_000_000) // Sleep 0.2 seconds to check for updates
            }
        }
    }
    
    func refreshCheckIns() async {
        isLoading = true
        defer { isLoading = false }
        
        await loadCheckIns()
    }
    
    // MARK: - Cleanup
    
    func cleanup() async {
        // Unsubscribe from real-time updates when leaving the pack detail view
        await realtimeFeedManager.unsubscribeFrom(subscriptionId: "pack_feed:\(packId)")
    }
}