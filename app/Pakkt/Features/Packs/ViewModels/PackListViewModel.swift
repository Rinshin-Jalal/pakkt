import Foundation
import SwiftUI
import Combine

@MainActor
class PackListViewModel: BaseViewModel {
    @Published var packs: [Pack] = []
    @Published var isRefreshing = false
    
    private let packsService: PacksService

    init(packsService: PacksService = PacksService()) {
        self.packsService = packsService
        super.init()
    }

    func loadPacks() async {
        do {
            let packs = try await withLoading {
                try await self.packsService.listPacks()
            }
            self.packs = packs
        } catch {
            handleError(error)
        }
    }

    func refreshPacks() async {
        isRefreshing = true
        defer { isRefreshing = false }

        await loadPacks()
    }

    func createPack(name: String, goalType: String? = nil) async {
        do {
            let request = CreatePackRequest(name: name, goalType: goalType)
            let pack = try await withLoading {
                try await self.packsService.createPack(request)
            }
            
            packs.append(pack)
        } catch {
            handleError(error)
        }
    }

    func dissolvePack(_ packId: UUID) async {
        do {
            try await withLoading {
                try await self.packsService.dissolvePack(id: packId)
            }

            packs.removeAll { $0.id == packId }
        } catch {
            handleError(error)
        }
    }
}
