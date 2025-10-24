import Foundation
import KeychainAccess

final class KeychainService {
    private let keychain: Keychain
    private let authTokenKey = "authToken"
    private let refreshTokenKey = "refreshToken"

    init(serviceName: String = "com.pakkt.app") {
        self.keychain = Keychain(service: serviceName)
    }

    // MARK: - Auth Token

    func saveAuthToken(_ token: String) throws {
        try keychain.set(token, key: authTokenKey)
    }

    func getAuthToken() throws -> String? {
        try keychain.getString(authTokenKey)
    }

    func deleteAuthToken() throws {
        try keychain.remove(authTokenKey)
    }

    // MARK: - Refresh Token

    func saveRefreshToken(_ token: String) throws {
        try keychain.set(token, key: refreshTokenKey)
    }

    func getRefreshToken() throws -> String? {
        try keychain.getString(refreshTokenKey)
    }

    func deleteRefreshToken() throws {
        try keychain.remove(refreshTokenKey)
    }

    // MARK: - Clear All

    func clearAll() throws {
        try keychain.removeAll()
    }
}
