import Foundation
import SwiftUI
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    func withLoading<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            return try await operation()
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }

    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }

    func clearError() {
        errorMessage = nil
    }
}
