import Foundation
import SwiftUI
import Combine
import AuthenticationServices

@MainActor
class AuthViewModel: BaseViewModel {
    @Published var isAuthenticated = false
    @Published var showError = false
    @Published var showEmailAuth = false
    @Published var isSignUpMode = false
    @Published var email = ""
    @Published var password = ""
    
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
    
    func signInWithEmail() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            showError = true
            return
        }
        
        do {
            try await withLoading {
                _ = try await SupabaseClient.shared.signInWithEmail(email: self.email, password: self.password)
                self.isAuthenticated = true
            }
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection"
            case .cannotConnectToHost:
                errorMessage = "Cannot connect to server. Check your network."
            case .timedOut:
                errorMessage = "Request timed out"
            default:
                errorMessage = "Network error: \(error.localizedDescription)"
            }
            showError = true
            print("❌ URLError: \(error)")
        } catch {
            errorMessage = "Sign in failed. Please check your credentials."
            showError = true
            print("❌ Sign in error: \(error)")
        }
    }
    
    func signUpWithEmail() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            showError = true
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            showError = true
            return
        }
        
        do {
            try await withLoading {
                _ = try await SupabaseClient.shared.signUpWithEmail(email: self.email, password: self.password)
                self.isAuthenticated = true
            }
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection"
            case .cannotConnectToHost:
                errorMessage = "Cannot connect to server. Check your network."
            case .timedOut:
                errorMessage = "Request timed out"
            default:
                errorMessage = "Network error: \(error.localizedDescription)"
            }
            showError = true
            print("❌ URLError: \(error)")
        } catch {
            errorMessage = "Sign up failed. Please try again."
            showError = true
            print("❌ Sign up error: \(error)")
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
