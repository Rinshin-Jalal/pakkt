import Foundation
import SwiftUI
import Combine

@MainActor
class PackAdminViewModel: BaseViewModel {
    @Published var pack: Pack?
    @Published var members: [PackMember] = []
    @Published var inviteCodes: [PackInviteCode] = []
    
    private let packsService: PacksService
    var packId: UUID?
    
    init(packsService: PacksService = PacksService()) {
        self.packsService = packsService
        super.init()
    }
    
    func loadPackData() async {
        guard let packId = packId else { return }
        
        do {
            let (pack, members, codes) = try await withLoading {
                async let packFetch = self.packsService.getPack(id: packId)
                async let membersFetch = self.packsService.getMembers(packId: packId)
                async let codesFetch = self.packsService.listInviteCodes(packId: packId)
                
                return try await (packFetch, membersFetch, codesFetch)
            }
            
            self.pack = pack
            self.members = members
            self.inviteCodes = codes
        } catch {
            handleError(error)
        }
    }
    
    func createInviteCode(maxUses: Int, expiresInHours: Int) async -> PackInviteCode? {
        guard let packId = packId else { return nil }
        
        do {
            let request = CreateInviteCodeRequest(maxUses: maxUses, expiresInHours: expiresInHours)
            let code = try await withLoading {
                try await self.packsService.createInviteCode(packId: packId, request: request)
            }
            
            // Reload codes
            await loadInviteCodes()
            return code
        } catch {
            handleError(error)
            return nil
        }
    }
    
    func deactivateInviteCode(_ codeId: UUID) async {
        guard let packId = packId else { return }
        
        do {
            try await withLoading {
                try await self.packsService.deactivateInviteCode(packId: packId, codeId: codeId)
            }
            await loadInviteCodes()
        } catch {
            handleError(error)
        }
    }
    
    func removeMember(_ userId: UUID) async -> Bool {
        guard let packId = packId else { return false }
        
        do {
            try await withLoading {
                try await self.packsService.removeMember(packId: packId, userId: userId)
            }
            await loadMembers()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    private func loadInviteCodes() async {
        guard let packId = packId else { return }
        
        do {
            let codes = try await packsService.listInviteCodes(packId: packId)
            self.inviteCodes = codes
        } catch {
            handleError(error)
        }
    }
    
    private func loadMembers() async {
        guard let packId = packId else { return }
        
        do {
            let members = try await packsService.getMembers(packId: packId)
            self.members = members
        } catch {
            handleError(error)
        }
    }
}
