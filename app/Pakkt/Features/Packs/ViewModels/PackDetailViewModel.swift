import Foundation
import SwiftUI
import Combine

@MainActor
class PackDetailViewModel: BaseViewModel {
    @Published var pack: Pack?
    @Published var checkIns: [CheckIn] = []
    @Published var isLoading = false
    
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
        do {
            let pack = try await withLoading {
                try await packsService.getPack(id: UUID(uuidString: packId) ?? UUID())
            }
            self.pack = pack
            
            // Start listening for check-in updates for this pack
            await startRealtimeCheckInUpdates()
        } catch {
            handleError(error)
        }
    }
    
    func loadCheckIns() async {
        do {
            let checkIns = try await withLoading {
                try await checkInsService.getPackCheckIns(packId: UUID(uuidString: packId) ?? UUID())
            }
            self.checkIns = checkIns
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
                        await MainActor.run {
                            Task {
                                await refreshCheckIns()
                            }
                        }
                        lastRefreshTime = now
                        // Reset the flag after processing
                        await MainActor.run {
                            await realtimeFeedManager.resetRefreshFlag()
                        }
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