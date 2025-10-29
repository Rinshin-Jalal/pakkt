import Foundation
import AuthenticationServices

actor SupabaseClient {
    static let shared = SupabaseClient()

    private let baseURL = APIConfiguration.supabaseURL
    private let apiKey = APIConfiguration.supabaseAnonKey

    private var currentSession: Session?

    private init() {}

    // MARK: - Authentication

    func signInWithApple(idToken: String, nonce: String) async throws -> Session {
        // Authenticate directly with Supabase
        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=id_token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "provider": "apple",
            "id_token": idToken,
            "nonce": nonce
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unauthorized
        }

        let session = try JSONDecoder().decode(Session.self, from: data)
        self.currentSession = session
        
        // Store the Supabase JWT token in keychain for backend API authentication
        let keychainService = KeychainService()
        try keychainService.saveAuthToken(session.accessToken)
        try keychainService.saveRefreshToken(session.refreshToken)
        
        return session
    }
    
    func signInWithEmail(email: String, password: String) async throws -> Session {
        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unauthorized
        }
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        self.currentSession = session
        
        // Store tokens in keychain
        let keychainService = KeychainService()
        try keychainService.saveAuthToken(session.accessToken)
        try keychainService.saveRefreshToken(session.refreshToken)
        
        return session
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> Session {
        let url = URL(string: "\(baseURL)/auth/v1/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.unauthorized
        }
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        self.currentSession = session
        
        // Store tokens in keychain
        let keychainService = KeychainService()
        try keychainService.saveAuthToken(session.accessToken)
        try keychainService.saveRefreshToken(session.refreshToken)
        
        return session
    }

    func signOut() async throws {
        let url = URL(string: "\(baseURL)/auth/v1/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")

        if let accessToken = currentSession?.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unauthorized
        }

        self.currentSession = nil
        
        // Clear tokens from keychain
        let keychainService = KeychainService()
        try keychainService.deleteAuthToken()
        try keychainService.deleteRefreshToken()
    }

    func getCurrentSession() -> Session? {
        return currentSession
    }

    func restoreSessionFromKeychain() async throws -> Session? {
        let keychainService = KeychainService()
        
        guard let accessToken = try? keychainService.getAuthToken(),
              let refreshToken = try? keychainService.getRefreshToken() else {
            return nil
        }
        
        // Verify the access token is still valid by getting user info
        let url = URL(string: "\(baseURL)/auth/v1/user")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                // Token is invalid, try to refresh
                return try await refreshSessionFromKeychain()
            }
            
            let user = try JSONDecoder().decode(User.self, from: data)
            let session = Session(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresIn: 3600, // Default value
                tokenType: "bearer",
                user: user
            )
            
            self.currentSession = session
            return session
        } catch {
            // Try to refresh the token
            return try await refreshSessionFromKeychain()
        }
    }

    private func refreshSessionFromKeychain() async throws -> Session? {
        let keychainService = KeychainService()
        
        guard let refreshToken = try? keychainService.getRefreshToken() else {
            // No refresh token, clear everything
            try keychainService.deleteAuthToken()
            try keychainService.deleteRefreshToken()
            return nil
        }

        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=refresh_token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "refresh_token": refreshToken
        ]
        request.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                // Refresh failed, clear tokens
                try keychainService.deleteAuthToken()
                try keychainService.deleteRefreshToken()
                return nil
            }

            let session = try JSONDecoder().decode(Session.self, from: data)
            self.currentSession = session
            
            // Update stored tokens
            try keychainService.saveAuthToken(session.accessToken)
            try keychainService.saveRefreshToken(session.refreshToken)
            
            return session
        } catch {
            // Refresh failed, clear tokens
            try keychainService.deleteAuthToken()
            try keychainService.deleteRefreshToken()
            return nil
        }
    }

    func refreshSession() async throws -> Session {
        guard let currentSession = currentSession else {
            throw APIError.unauthorized
        }

        let url = URL(string: "\(baseURL)/auth/v1/token?grant_type=refresh_token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "refresh_token": currentSession.refreshToken
        ]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.unauthorized
        }

        let session = try JSONDecoder().decode(Session.self, from: data)
        self.currentSession = session
        
        // Update stored tokens
        let keychainService = KeychainService()
        try keychainService.saveAuthToken(session.accessToken)
        try keychainService.saveRefreshToken(session.refreshToken)
        
        return session
    }
}

// MARK: - Models

struct Session: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case user
    }
}

struct User: Codable {
    let id: String
    let email: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}
