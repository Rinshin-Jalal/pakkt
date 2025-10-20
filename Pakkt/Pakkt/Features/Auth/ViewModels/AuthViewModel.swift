import Foundation
import SwiftUI
import Combine
import AuthenticationServices

@MainActor
class AuthViewModel: BaseViewModel {
    @Published var isAuthenticated = false
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
        if let _ = await SupabaseClient.shared.getCurrentSession() {
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }
}
