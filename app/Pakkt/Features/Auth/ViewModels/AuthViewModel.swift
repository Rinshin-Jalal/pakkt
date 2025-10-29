import Foundation
import SwiftUI
import Combine
import AuthenticationServices

@MainActor
class AuthViewModel: BaseViewModel {
    @Published var isAuthenticated = false
    @Published var showError = false
    private let appleSignInService = AppleSignInService()

    func signInWithApple() async {
        do {
            try await withLoading {
                try await self.appleSignInService.signIn()
                self.isAuthenticated = true
            }
        } catch {
            handleError(error)
        }
    }

    func signOut() async {
        do {
            try await withLoading {
                try await SupabaseClient.shared.signOut()
                self.isAuthenticated = false
            }
        } catch {
            handleError(error)
        }
    }

    func checkAuthStatus() async {
        do {
            if let _ = try await SupabaseClient.shared.restoreSessionFromKeychain() {
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
            }
        } catch {
            self.isAuthenticated = false
        }
    }
    
    override func handleError(_ error: Error) {
        super.handleError(error)
        showError = true
    }
    
    override func clearError() {
        super.clearError()
        showError = false
    }
}
