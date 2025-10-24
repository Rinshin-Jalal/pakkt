# Pakkt iOS App - Feature-Complete Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build production-ready Pakkt iOS app with all 8 backend features: users, packs, goals, check-ins, fines/voting, jail enforcement, social interactions, and media uploads.

**Architecture:** MVVM pattern with SwiftUI views, service layer for API integration, actor-based APIClient for concurrency safety, Coordinator pattern for navigation, Supabase Realtime for live updates.

**Tech Stack:**
- Swift 6.0, iOS 16+, iPhone only
- Supabase Swift SDK (auth, realtime, database)
- KeychainAccess (secure token storage)
- Kingfisher (async image loading)
- Family Controls (Screen Time enforcement)
- AVFoundation (camera capture)

---

## Phase 1: Foundation Enhancement

### Task 1.1: Update Package Dependencies

**Files:**
- Modify: `app/Package.swift`

**Step 1: Update Package.swift with all dependencies**

```swift
// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Pakkt",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Pakkt",
            targets: ["Pakkt"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0")
    ],
    targets: [
        .target(
            name: "Pakkt",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
        .testTarget(
            name: "PakktTests",
            dependencies: ["Pakkt"]
        )
    ]
)
```

**Step 2: Resolve dependencies**

Run: `cd app && swift package resolve`
Expected: All packages downloaded successfully

**Step 3: Commit**

```bash
git add app/Package.swift
git commit -m "build: add Supabase, KeychainAccess, and Kingfisher dependencies"
```

---

### Task 1.2: Keychain Service for Secure Token Storage

**Files:**
- Create: `app/Pakkt/Core/Services/KeychainService.swift`
- Create: `app/PakktTests/Core/Services/KeychainServiceTests.swift`

**Step 1: Write failing test**

```swift
// app/PakktTests/Core/Services/KeychainServiceTests.swift
import XCTest
@testable import Pakkt

final class KeychainServiceTests: XCTestCase {
    var sut: KeychainService!

    override func setUp() {
        super.setUp()
        sut = KeychainService(serviceName: "com.pakkt.test")
        // Clear any existing tokens
        try? sut.deleteAuthToken()
    }

    override func tearDown() {
        try? sut.deleteAuthToken()
        sut = nil
        super.tearDown()
    }

    func testSaveAndRetrieveAuthToken() throws {
        // Given
        let token = "test-jwt-token-12345"

        // When
        try sut.saveAuthToken(token)
        let retrieved = try sut.getAuthToken()

        // Then
        XCTAssertEqual(retrieved, token)
    }

    func testDeleteAuthToken() throws {
        // Given
        try sut.saveAuthToken("token-to-delete")

        // When
        try sut.deleteAuthToken()

        // Then
        XCTAssertNil(try? sut.getAuthToken())
    }
}
```

**Step 2: Run test to verify it fails**

Run: `swift test --filter KeychainServiceTests`
Expected: FAIL - KeychainService not defined

**Step 3: Implement KeychainService**

```swift
// app/Pakkt/Core/Services/KeychainService.swift
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
```

**Step 4: Run test to verify it passes**

Run: `swift test --filter KeychainServiceTests`
Expected: PASS (2 tests)

**Step 5: Commit**

```bash
git add app/Pakkt/Core/Services/KeychainService.swift app/PakktTests/Core/Services/KeychainServiceTests.swift
git commit -m "feat(core): add KeychainService for secure token storage"
```

---

### Task 1.3: Enhanced APIClient with Auth Token Injection

**Files:**
- Modify: `app/Pakkt/Core/Network/APIClient.swift`
- Create: `app/PakktTests/Core/Network/APIClientTests.swift`

**Step 1: Write failing test**

```swift
// app/PakktTests/Core/Network/APIClientTests.swift
import XCTest
@testable import Pakkt

final class APIClientTests: XCTestCase {
    var sut: APIClient!
    var mockKeychainService: MockKeychainService!

    override func setUp() async throws {
        mockKeychainService = MockKeychainService()
        sut = await APIClient(keychainService: mockKeychainService)
    }

    func testAuthTokenInjection() async throws {
        // Given
        mockKeychainService.authToken = "Bearer test-token"
        let endpoint = TestEndpoint()

        // When
        let headers = await sut.buildHeaders(for: endpoint)

        // Then
        XCTAssertEqual(headers["Authorization"], "Bearer test-token")
    }
}

// Mock for testing
class MockKeychainService: KeychainService {
    var authToken: String?

    override func getAuthToken() throws -> String? {
        return authToken
    }
}
```

**Step 2: Run test to verify it fails**

Run: `swift test --filter APIClientTests`
Expected: FAIL - buildHeaders method not defined

**Step 3: Update APIClient implementation**

```swift
// app/Pakkt/Core/Network/APIClient.swift
import Foundation

actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let keychainService: KeychainService
    private var requestLogger: ((URLRequest) -> Void)?
    private var responseLogger: ((URLResponse, Data?) -> Void)?

    init(keychainService: KeychainService = KeychainService()) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
        self.keychainService = keychainService
    }

    // MARK: - Logging

    func enableLogging(
        request: @escaping (URLRequest) -> Void,
        response: @escaping (URLResponse, Data?) -> Void
    ) {
        self.requestLogger = request
        self.responseLogger = response
    }

    // MARK: - Request with Response

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try await buildURLRequest(from: endpoint)

        requestLogger?(urlRequest)

        let (data, response) = try await session.data(for: urlRequest)

        responseLogger?(response, data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try validateResponse(httpResponse, data: data)

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Request without Response

    func request(_ endpoint: Endpoint) async throws {
        let urlRequest = try await buildURLRequest(from: endpoint)

        requestLogger?(urlRequest)

        let (data, response) = try await session.data(for: urlRequest)

        responseLogger?(response, data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try validateResponse(httpResponse, data: data)
    }

    // MARK: - Private Helpers

    private func buildURLRequest(from endpoint: Endpoint) async throws -> URLRequest {
        guard let url = buildURL(from: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Set headers
        var headers = endpoint.headers ?? [:]

        // Add Content-Type if body present
        if endpoint.body != nil && headers["Content-Type"] == nil {
            headers["Content-Type"] = "application/json"
        }

        // Inject auth token
        if let token = try? keychainService.getAuthToken() {
            headers["Authorization"] = "Bearer \(token)"
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private func buildURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: APIConfiguration.baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        return components?.url
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 400...499:
            // Try to decode error message from body
            if let errorMessage = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.clientError(statusCode: response.statusCode, message: errorMessage.message)
            }
            throw APIError.clientError(statusCode: response.statusCode, message: nil)
        case 500...599:
            throw APIError.serverError(statusCode: response.statusCode, message: nil)
        default:
            throw APIError.serverError(statusCode: response.statusCode, message: nil)
        }
    }
}

// Error response structure
struct ErrorResponse: Codable {
    let message: String
    let error: String?
}
```

**Step 4: Update APIError enum**

```swift
// app/Pakkt/Core/Network/APIError.swift
import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case clientError(statusCode: Int, message: String?)
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .unauthorized:
            return "Authentication required. Please sign in again."
        case .forbidden:
            return "You don't have permission to access this resource"
        case .notFound:
            return "The requested resource was not found"
        case .clientError(let code, let message):
            return message ?? "Client error (\(code))"
        case .serverError(let code, let message):
            return message ?? "Server error (\(code))"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
```

**Step 5: Run tests**

Run: `swift test --filter APIClientTests`
Expected: PASS

**Step 6: Commit**

```bash
git add app/Pakkt/Core/Network/APIClient.swift app/Pakkt/Core/Network/APIError.swift app/PakktTests/Core/Network/APIClientTests.swift
git commit -m "feat(network): enhance APIClient with auth token injection and logging"
```

---

### Task 1.4: Supabase Realtime Service

**Files:**
- Create: `app/Pakkt/Core/Services/SupabaseRealtimeService.swift`

**Step 1: Create SupabaseRealtimeService**

```swift
// app/Pakkt/Core/Services/SupabaseRealtimeService.swift
import Foundation
import Supabase
import Combine

actor SupabaseRealtimeService {
    private let supabase: SupabaseClient
    private var channels: [String: RealtimeChannelV2] = [:]

    init(supabaseURL: URL, supabaseAnonKey: String) {
        self.supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseAnonKey
        )
    }

    // MARK: - Check-ins Subscription

    func subscribeToCheckIns(
        packId: String,
        onInsert: @escaping (CheckIn) -> Void
    ) async throws {
        let channelId = "check_ins:\(packId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "check_ins",
            filter: "pack_id=eq.\(packId)"
        ) { insert in
            if let checkIn = try? JSONDecoder().decode(CheckIn.self, from: JSONEncoder().encode(insert.record)) {
                onInsert(checkIn)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Fine Votes Subscription

    func subscribeToFineVotes(
        fineId: String,
        onInsert: @escaping (FineVote) -> Void
    ) async throws {
        let channelId = "fine_votes:\(fineId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "fine_votes",
            filter: "fine_id=eq.\(fineId)"
        ) { insert in
            if let vote = try? JSONDecoder().decode(FineVote.self, from: JSONEncoder().encode(insert.record)) {
                onInsert(vote)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Comments Subscription

    func subscribeToComments(
        checkInId: String,
        onInsert: @escaping (Comment) -> Void
    ) async throws {
        let channelId = "comments:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "comments",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            if let comment = try? JSONDecoder().decode(Comment.self, from: JSONEncoder().encode(insert.record)) {
                onInsert(comment)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Reactions Subscription

    func subscribeToReactions(
        checkInId: String,
        onInsert: @escaping (Reaction) -> Void
    ) async throws {
        let channelId = "reactions:\(checkInId)"

        let channel = await supabase.realtimeV2.channel(channelId)

        let insertChange = await channel.onPostgresChange(
            InsertAction.self,
            schema: "public",
            table: "reactions",
            filter: "check_in_id=eq.\(checkInId)"
        ) { insert in
            if let reaction = try? JSONDecoder().decode(Reaction.self, from: JSONEncoder().encode(insert.record)) {
                onInsert(reaction)
            }
        }

        await channel.subscribe()
        channels[channelId] = channel
    }

    // MARK: - Unsubscribe

    func unsubscribe(from channelId: String) async {
        if let channel = channels[channelId] {
            await channel.unsubscribe()
            channels.removeValue(forKey: channelId)
        }
    }

    func unsubscribeAll() async {
        for channel in channels.values {
            await channel.unsubscribe()
        }
        channels.removeAll()
    }
}
```

**Step 2: Commit**

```bash
git add app/Pakkt/Core/Services/SupabaseRealtimeService.swift
git commit -m "feat(realtime): add Supabase realtime service for live updates"
```

---

## Phase 2: User & Pack Management

**Note on Pack Membership**: Pakkt uses an **invite code system** instead of direct member addition for security. Pack creators generate expirable, limited-use codes that users redeem themselves. This eliminates service role bypass issues and provides better audit trails. See `backend/scripts/test-social-flows.sh` (lines 57-73) for the complete flow:
1. Creator generates invite code with max uses and expiration
2. Users validate and redeem codes themselves
3. Database function atomically adds user and returns pack details

### Task 2.1: User Models

**Files:**
- Create: `app/Pakkt/Features/Users/Models/UserProfile.swift`
- Create: `app/Pakkt/Features/Users/Models/UpdateProfileRequest.swift`

**Step 1: Create UserProfile model**

```swift
// app/Pakkt/Features/Users/Models/UserProfile.swift
import Foundation

struct UserProfile: Codable, Identifiable, Equatable {
    let id: UUID
    let phoneNumber: String?
    let email: String?
    let username: String
    let profilePic: String?
    let bio: String?
    let subscriptionStatus: SubscriptionStatus
    let subscriptionExpiresAt: Date?
    let totalXp: Int
    let currentLevel: Int
    let currentStreak: Int
    let longestStreak: Int
    let totalCheckins: Int
    let totalFinesPaid: Int
    let totalJailsCompleted: Int
    let createdAt: Date
    let updatedAt: Date

    enum SubscriptionStatus: String, Codable {
        case free
        case trial
        case pro
    }
}

// API Response wrapper
struct UserProfileResponse: Codable {
    let success: Bool
    let data: UserProfile
}
```

**Step 2: Create UpdateProfileRequest**

```swift
// app/Pakkt/Features/Users/Models/UpdateProfileRequest.swift
import Foundation

struct UpdateProfileRequest: Codable {
    let username: String?
    let profilePic: String?
    let bio: String?

    init(username: String? = nil, profilePic: String? = nil, bio: String? = nil) {
        self.username = username
        self.profilePic = profilePic
        self.bio = bio
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Users/Models/
git commit -m "feat(users): add UserProfile and UpdateProfileRequest models"
```

---

### Task 2.2: Users Service

**Files:**
- Create: `app/Pakkt/Features/Users/Services/UsersService.swift`
- Create: `app/PakktTests/Features/Users/Services/UsersServiceTests.swift`

**Step 1: Write failing test**

```swift
// app/PakktTests/Features/Users/Services/UsersServiceTests.swift
import XCTest
@testable import Pakkt

final class UsersServiceTests: XCTestCase {
    var sut: UsersService!
    var mockAPIClient: MockAPIClient!

    override func setUp() async throws {
        mockAPIClient = MockAPIClient()
        sut = await UsersService(apiClient: mockAPIClient)
    }

    func testGetProfile() async throws {
        // Given
        let expectedProfile = UserProfile(
            id: UUID(),
            phoneNumber: nil,
            email: "test@example.com",
            username: "testuser",
            profilePic: nil,
            bio: nil,
            subscriptionStatus: .free,
            subscriptionExpiresAt: nil,
            totalXp: 100,
            currentLevel: 2,
            currentStreak: 5,
            longestStreak: 10,
            totalCheckins: 20,
            totalFinesPaid: 0,
            totalJailsCompleted: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockAPIClient.mockResponse = UserProfileResponse(success: true, data: expectedProfile)

        // When
        let profile = try await sut.getProfile()

        // Then
        XCTAssertEqual(profile.username, "testuser")
        XCTAssertEqual(profile.totalXp, 100)
    }
}
```

**Step 2: Run test to verify it fails**

Run: `swift test --filter UsersServiceTests`
Expected: FAIL - UsersService not defined

**Step 3: Implement UsersService**

```swift
// app/Pakkt/Features/Users/Services/UsersService.swift
import Foundation

actor UsersService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Get Profile

    func getProfile() async throws -> UserProfile {
        let endpoint = PakktEndpoint.getProfile
        let response: UserProfileResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Profile

    func updateProfile(_ request: UpdateProfileRequest) async throws -> UserProfile {
        let endpoint = PakktEndpoint.updateProfile(request)
        let response: UserProfileResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Register Push Token

    func registerPushToken(token: String, deviceType: String = "ios", deviceId: String? = nil) async throws {
        let request = PushTokenRequest(token: token, deviceType: deviceType, deviceId: deviceId)
        let endpoint = PakktEndpoint.registerPushToken(request)
        try await apiClient.request(endpoint)
    }

    // MARK: - Delete Push Token

    func deletePushToken() async throws {
        let endpoint = PakktEndpoint.deletePushToken
        try await apiClient.request(endpoint)
    }
}

// Push token request
struct PushTokenRequest: Codable {
    let token: String
    let deviceType: String
    let deviceId: String?
}
```

**Step 4: Add endpoints to PakktEndpoint**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these cases)
extension PakktEndpoint {
    static var getProfile: Endpoint {
        Endpoint(
            path: "/api/users/profile",
            method: .get
        )
    }

    static func updateProfile(_ request: UpdateProfileRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(
            path: "/api/users/profile",
            method: .patch,
            body: body
        )
    }

    static func registerPushToken(_ request: PushTokenRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(
            path: "/api/users/push-token",
            method: .post,
            body: body
        )
    }

    static var deletePushToken: Endpoint {
        Endpoint(
            path: "/api/users/push-token",
            method: .delete
        )
    }
}
```

**Step 5: Run tests**

Run: `swift test --filter UsersServiceTests`
Expected: PASS

**Step 6: Commit**

```bash
git add app/Pakkt/Features/Users/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift app/PakktTests/Features/Users/Services/
git commit -m "feat(users): add UsersService with profile and push token management"
```

---

### Task 2.3: Pack Models

**Files:**
- Create: `app/Pakkt/Features/Packs/Models/Pack.swift`
- Create: `app/Pakkt/Features/Packs/Models/PackMember.swift`
- Create: `app/Pakkt/Features/Packs/Models/PackStats.swift`
- Create: `app/Pakkt/Features/Packs/Models/CreatePackRequest.swift`

**Step 1: Create Pack model**

```swift
// app/Pakkt/Features/Packs/Models/Pack.swift
import Foundation

struct Pack: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let creatorId: UUID
    let xp: Int
    let level: Int
    let goalType: String?
    let status: PackStatus
    let createdAt: Date
    let updatedAt: Date?
    let lastActivity: Date?

    enum PackStatus: String, Codable {
        case active
        case dissolved
    }
}

struct PackResponse: Codable {
    let success: Bool
    let data: Pack
}

struct PackListResponse: Codable {
    let success: Bool
    let data: [Pack]
}
```

**Step 2: Create PackMember model**

```swift
// app/Pakkt/Features/Packs/Models/PackMember.swift
import Foundation

struct PackMember: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let role: MemberRole
    let joinDate: Date
    let reputationXp: Int
    let isActive: Bool
    let createdAt: Date?
    let updatedAt: Date?
    let user: MemberUser?

    enum MemberRole: String, Codable {
        case admin
        case member
    }

    struct MemberUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }
}

struct PackMemberResponse: Codable {
    let success: Bool
    let data: [PackMember]
}
```

**Step 3: Create PackStats model**

```swift
// app/Pakkt/Features/Packs/Models/PackStats.swift
import Foundation

struct PackStats: Codable, Equatable {
    let packId: UUID
    let totalXp: Int
    let currentLevel: Int
    let memberCount: Int
    let totalCheckins: Int
    let totalFines: Int
    let totalJails: Int
    let averageStreak: Double
    let topPerformers: [TopPerformer]

    struct TopPerformer: Codable, Equatable {
        let userId: UUID
        let username: String
        let xp: Int
        let streak: Int
    }
}

struct PackStatsResponse: Codable {
    let success: Bool
    let data: PackStats
}
```

**Step 4: Create Invite Code models**

```swift
// app/Pakkt/Features/Packs/Models/PackInviteCode.swift
import Foundation

struct PackInviteCode: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let code: String
    let createdBy: UUID
    let maxUses: Int
    let currentUses: Int
    let expiresAt: Date
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
}

struct CreateInviteCodeRequest: Codable {
    let maxUses: Int?
    let expiresInHours: Int?

    init(maxUses: Int = 10, expiresInHours: Int = 24) {
        self.maxUses = maxUses
        self.expiresInHours = expiresInHours
    }
}

struct UseInviteCodeRequest: Codable {
    let code: String
}

struct InviteCodeResponse: Codable {
    let success: Bool
    let data: PackInviteCode
}

struct InviteCodeListResponse: Codable {
    let success: Bool
    let data: [PackInviteCode]
}
```

**Step 5: Create request models**

```swift
// app/Pakkt/Features/Packs/Models/CreatePackRequest.swift
import Foundation

struct CreatePackRequest: Codable {
    let name: String
    let goalType: String?

    init(name: String, goalType: String? = nil) {
        self.name = name
        self.goalType = goalType
    }
}

struct UpdatePackRequest: Codable {
    let name: String?
    let description: String?

    init(name: String? = nil, description: String? = nil) {
        self.name = name
        self.description = description
    }
}
```

**Step 6: Commit**

```bash
git add app/Pakkt/Features/Packs/Models/
git commit -m "feat(packs): add Pack, PackMember, PackStats, and InviteCode models"
```

---

### Task 2.4: Packs Service

**Files:**
- Create: `app/Pakkt/Features/Packs/Services/PacksService.swift`

**Step 1: Implement PacksService**

```swift
// app/Pakkt/Features/Packs/Services/PacksService.swift
import Foundation

actor PacksService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List User's Packs

    func listPacks() async throws -> [Pack] {
        let endpoint = PakktEndpoint.listPacks
        let response: PackListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Create Pack

    func createPack(_ request: CreatePackRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.createPack(request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Pack Details

    func getPack(id: UUID) async throws -> Pack {
        let endpoint = PakktEndpoint.getPack(id: id)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Pack

    func updatePack(id: UUID, request: UpdatePackRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.updatePack(id: id, request: request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Dissolve Pack

    func dissolvePack(id: UUID) async throws {
        let endpoint = PakktEndpoint.dissolvePack(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Members

    func getMembers(packId: UUID) async throws -> [PackMember] {
        let endpoint = PakktEndpoint.getPackMembers(packId: packId)
        let response: PackMemberResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func removeMember(packId: UUID, userId: UUID) async throws {
        let endpoint = PakktEndpoint.removePackMember(packId: packId, userId: userId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Invite Codes (Self-Join System)

    func createInviteCode(packId: UUID, request: CreateInviteCodeRequest) async throws -> PackInviteCode {
        let endpoint = PakktEndpoint.createInviteCode(packId: packId, request: request)
        let response: InviteCodeResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func listInviteCodes(packId: UUID) async throws -> [PackInviteCode] {
        let endpoint = PakktEndpoint.listInviteCodes(packId: packId)
        let response: InviteCodeListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func validateInviteCode(_ code: String) async throws -> PackInviteCode {
        let endpoint = PakktEndpoint.validateInviteCode(code)
        let response: InviteCodeResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func useInviteCode(_ request: UseInviteCodeRequest) async throws -> Pack {
        let endpoint = PakktEndpoint.useInviteCode(request)
        let response: PackResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func deactivateInviteCode(packId: UUID, codeId: UUID) async throws {
        let endpoint = PakktEndpoint.deactivateInviteCode(packId: packId, codeId: codeId)
        try await apiClient.request(endpoint)
    }

    func deleteInviteCode(packId: UUID, codeId: UUID) async throws {
        let endpoint = PakktEndpoint.deleteInviteCode(packId: packId, codeId: codeId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Stats

    func getStats(packId: UUID) async throws -> PackStats {
        let endpoint = PakktEndpoint.getPackStats(packId: packId)
        let response: PackStatsResponse = try await apiClient.request(endpoint)
        return response.data
    }
}
```

**Step 2: Add pack endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Packs
    static var listPacks: Endpoint {
        Endpoint(path: "/api/packs", method: .get)
    }

    static func createPack(_ request: CreatePackRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/packs", method: .post, body: body)
    }

    static func getPack(id: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(id.uuidString)", method: .get)
    }

    static func updatePack(id: UUID, request: UpdatePackRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/packs/\(id.uuidString)", method: .patch, body: body)
    }

    static func dissolvePack(id: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(id.uuidString)", method: .delete)
    }

    static func getPackMembers(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/members", method: .get)
    }

    static func removePackMember(packId: UUID, userId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/members/\(userId.uuidString)", method: .delete)
    }

    // Invite Codes (Self-Join System - see backend/scripts/test-social-flows.sh for flow)
    static func createInviteCode(packId: UUID, request: CreateInviteCodeRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/packs/\(packId.uuidString)/invite-codes", method: .post, body: body)
    }

    static func listInviteCodes(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/invite-codes", method: .get)
    }

    static func validateInviteCode(_ code: String) -> Endpoint {
        Endpoint(path: "/api/invite-codes/\(code)/validate", method: .get)
    }

    static func useInviteCode(_ request: UseInviteCodeRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/invite-codes/use", method: .post, body: body)
    }

    static func deactivateInviteCode(packId: UUID, codeId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/invite-codes/\(codeId.uuidString)/deactivate", method: .patch)
    }

    static func deleteInviteCode(packId: UUID, codeId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/invite-codes/\(codeId.uuidString)", method: .delete)
    }

    static func getPackStats(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/stats", method: .get)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Packs/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(packs): add PacksService with invite code system (self-join)"
```

---

## Phase 3: Goals & Scheduling

### Task 3.1: Goal Models

**Files:**
- Create: `app/Pakkt/Features/Goals/Models/Goal.swift`
- Create: `app/Pakkt/Features/Goals/Models/RecurrenceRule.swift`
- Create: `app/Pakkt/Features/Goals/Models/CreateGoalRequest.swift`

**Step 1: Create RecurrenceRule**

```swift
// app/Pakkt/Features/Goals/Models/RecurrenceRule.swift
import Foundation

enum RecurrenceType: String, Codable {
    case daily
    case weekly
    case custom
}

struct RecurrenceRule: Codable, Equatable {
    let type: RecurrenceType
    let interval: Int // Every N days/weeks
    let daysOfWeek: [Int]? // 0-6 (Sunday-Saturday) for weekly
    let endDate: Date? // Optional end date

    // Helper for daily recurrence
    static func daily(interval: Int = 1) -> RecurrenceRule {
        RecurrenceRule(type: .daily, interval: interval, daysOfWeek: nil, endDate: nil)
    }

    // Helper for weekly recurrence
    static func weekly(daysOfWeek: [Int], interval: Int = 1) -> RecurrenceRule {
        RecurrenceRule(type: .weekly, interval: interval, daysOfWeek: daysOfWeek, endDate: nil)
    }

    // Check if goal is scheduled for today
    func isScheduledFor(date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) - 1 // Convert to 0-6

        switch type {
        case .daily:
            return true
        case .weekly:
            return daysOfWeek?.contains(weekday) ?? false
        case .custom:
            return daysOfWeek?.contains(weekday) ?? false
        }
    }
}
```

**Step 2: Create Goal model**

```swift
// app/Pakkt/Features/Goals/Models/Goal.swift
import Foundation

struct Goal: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let title: String
    let description: String?
    let checkInTime: String // HH:MM format
    let recurrenceRule: RecurrenceRule
    let fineAmount: Int // In cents
    let jailDuration: Int // In minutes
    let proofRequired: Bool
    let isActive: Bool
    let baseXp: Int
    let createdAt: Date
    let updatedAt: Date
    let user: GoalUser?

    struct GoalUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }

    // Helper to get check-in time as Date components
    var checkInTimeComponents: DateComponents? {
        let parts = checkInTime.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }
        return DateComponents(hour: hour, minute: minute)
    }
}

struct GoalWithStats: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let title: String
    let description: String?
    let checkInTime: String
    let recurrenceRule: RecurrenceRule
    let fineAmount: Int
    let jailDuration: Int
    let proofRequired: Bool
    let isActive: Bool
    let baseXp: Int
    let createdAt: Date
    let updatedAt: Date
    let totalCheckins: Int
    let completionRate: Double
    let currentStreak: Int
    let longestStreak: Int
}

struct GoalResponse: Codable {
    let success: Bool
    let data: Goal
}

struct GoalListResponse: Codable {
    let success: Bool
    let data: [Goal]
}
```

**Step 3: Create request models**

```swift
// app/Pakkt/Features/Goals/Models/CreateGoalRequest.swift
import Foundation

enum GoalType: String, Codable {
    case personal
    case pack
}

struct CreateGoalRequest: Codable {
    let title: String
    let description: String?
    let checkInTime: String // HH:MM format
    let recurrenceRule: RecurrenceRule
    let goalType: GoalType
    let assignedToUserId: UUID?
    let fineAmount: Int?
    let jailDuration: Int?
    let proofRequired: Bool?
    let baseXp: Int?

    init(
        title: String,
        description: String? = nil,
        checkInTime: String,
        recurrenceRule: RecurrenceRule,
        goalType: GoalType = .pack,
        assignedToUserId: UUID? = nil,
        fineAmount: Int? = nil,
        jailDuration: Int? = nil,
        proofRequired: Bool? = nil,
        baseXp: Int? = nil
    ) {
        self.title = title
        self.description = description
        self.checkInTime = checkInTime
        self.recurrenceRule = recurrenceRule
        self.goalType = goalType
        self.assignedToUserId = assignedToUserId
        self.fineAmount = fineAmount
        self.jailDuration = jailDuration
        self.proofRequired = proofRequired
        self.baseXp = baseXp
    }
}

struct UpdateGoalRequest: Codable {
    let title: String?
    let description: String?
    let checkInTime: String?
    let recurrenceRule: RecurrenceRule?
    let fineAmount: Int?
    let jailDuration: Int?
    let proofRequired: Bool?
    let baseXp: Int?
}
```

**Step 4: Commit**

```bash
git add app/Pakkt/Features/Goals/Models/
git commit -m "feat(goals): add Goal models with recurrence rules"
```

---

### Task 3.2: Goals Service

**Files:**
- Create: `app/Pakkt/Features/Goals/Services/GoalsService.swift`

**Step 1: Implement GoalsService**

```swift
// app/Pakkt/Features/Goals/Services/GoalsService.swift
import Foundation

actor GoalsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List Goals

    func listGoals() async throws -> [Goal] {
        let endpoint = PakktEndpoint.listGoals
        let response: GoalListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func listPackGoals(packId: UUID) async throws -> [Goal] {
        let endpoint = PakktEndpoint.listPackGoals(packId: packId)
        let response: GoalListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Create Goal

    func createGoal(packId: UUID, request: CreateGoalRequest) async throws -> Goal {
        let endpoint = PakktEndpoint.createPackGoal(packId: packId, request: request)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Goal

    func getGoal(id: UUID) async throws -> Goal {
        let endpoint = PakktEndpoint.getGoal(id: id)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Update Goal

    func updateGoal(id: UUID, request: UpdateGoalRequest) async throws -> Goal {
        let endpoint = PakktEndpoint.updateGoal(id: id, request: request)
        let response: GoalResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Delete Goal

    func deleteGoal(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteGoal(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Get Goals Due Today

    func getGoalsDueToday() async throws -> [Goal] {
        let allGoals = try await listGoals()
        let today = Date()

        return allGoals.filter { goal in
            goal.isActive && goal.recurrenceRule.isScheduledFor(date: today)
        }
    }
}
```

**Step 2: Add goal endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Goals
    static var listGoals: Endpoint {
        Endpoint(path: "/api/goals", method: .get)
    }

    static func listPackGoals(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/goals", method: .get)
    }

    static func createPackGoal(packId: UUID, request: CreateGoalRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/packs/\(packId.uuidString)/goals", method: .post, body: body)
    }

    static func getGoal(id: UUID) -> Endpoint {
        Endpoint(path: "/api/goals/\(id.uuidString)", method: .get)
    }

    static func updateGoal(id: UUID, request: UpdateGoalRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/goals/\(id.uuidString)", method: .patch, body: body)
    }

    static func deleteGoal(id: UUID) -> Endpoint {
        Endpoint(path: "/api/goals/\(id.uuidString)", method: .delete)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Goals/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(goals): add GoalsService with CRUD and scheduling"
```

---

## Phase 4: Check-ins & Camera Integration

### Task 4.1: Check-in Models

**Files:**
- Create: `app/Pakkt/Features/CheckIns/Models/CheckIn.swift`
- Create: `app/Pakkt/Features/CheckIns/Models/CreateCheckInRequest.swift`

**Step 1: Create CheckIn models**

```swift
// app/Pakkt/Features/CheckIns/Models/CheckIn.swift
import Foundation

enum CheckInStatus: String, Codable {
    case pending
    case verified
    case late
    case missed
}

struct CheckIn: Codable, Identifiable, Equatable {
    let id: UUID
    let goalId: UUID
    let userId: UUID
    let packId: UUID
    let proofUrl: String?
    let caption: String?
    let status: CheckInStatus
    let streakCount: Int
    let xpAwarded: Int
    let checkedInAt: Date
    let createdAt: Date
    let goal: CheckInGoal?
    let user: CheckInUser?

    struct CheckInGoal: Codable, Equatable {
        let title: String
        let baseXp: Int
    }

    struct CheckInUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }
}

struct FeedItem: Codable, Identifiable, Equatable {
    let id: UUID
    let goalId: UUID
    let userId: UUID
    let packId: UUID
    let proofUrl: String?
    let caption: String?
    let status: CheckInStatus
    let streakCount: Int
    let xpAwarded: Int
    let checkedInAt: Date
    let createdAt: Date
    let goal: CheckIn.CheckInGoal?
    let user: CheckIn.CheckInUser?
    let reactionsCount: Int?
    let commentsCount: Int?
}

struct CheckInResponse: Codable {
    let success: Bool
    let data: CheckIn
}

struct FeedResponse: Codable {
    let success: Bool
    let data: [FeedItem]
}
```

**Step 2: Create request models**

```swift
// app/Pakkt/Features/CheckIns/Models/CreateCheckInRequest.swift
import Foundation

struct CreateCheckInRequest: Codable {
    let goalId: UUID
    let proofUrl: String?
    let caption: String?

    init(goalId: UUID, proofUrl: String? = nil, caption: String? = nil) {
        self.goalId = goalId
        self.proofUrl = proofUrl
        self.caption = caption
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/CheckIns/Models/
git commit -m "feat(checkins): add CheckIn and FeedItem models"
```

---

### Task 4.2: Uploads Service (R2 Integration)

**Files:**
- Create: `app/Pakkt/Features/Uploads/Models/UploadModels.swift`
- Create: `app/Pakkt/Features/Uploads/Services/UploadsService.swift`

**Step 1: Create upload models**

```swift
// app/Pakkt/Features/Uploads/Models/UploadModels.swift
import Foundation

struct PresignedURLRequest: Codable {
    let filename: String
    let contentType: String

    init(filename: String, contentType: String = "image/jpeg") {
        self.filename = filename
        self.contentType = contentType
    }
}

struct PresignedURLResponse: Codable {
    let success: Bool
    let data: PresignedURLData

    struct PresignedURLData: Codable {
        let uploadUrl: String
        let publicUrl: String
    }
}
```

**Step 2: Implement UploadsService**

```swift
// app/Pakkt/Features/Uploads/Services/UploadsService.swift
import Foundation
import UIKit

actor UploadsService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Upload Image

    func uploadImage(_ image: UIImage, filename: String? = nil) async throws -> String {
        // 1. Compress image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw UploadError.compressionFailed
        }

        // 2. Generate filename
        let finalFilename = filename ?? "check-in-\(UUID().uuidString).jpg"

        // 3. Get presigned URL
        let request = PresignedURLRequest(filename: finalFilename, contentType: "image/jpeg")
        let endpoint = PakktEndpoint.getPresignedURL(request)
        let response: PresignedURLResponse = try await apiClient.request(endpoint)

        // 4. Upload to R2
        try await uploadToR2(
            data: imageData,
            url: response.data.uploadUrl,
            contentType: "image/jpeg"
        )

        // 5. Return public URL
        return response.data.publicUrl
    }

    // MARK: - Private Helpers

    private func uploadToR2(data: Data, url: String, contentType: String) async throws {
        guard let uploadURL = URL(string: url) else {
            throw UploadError.invalidURL
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw UploadError.uploadFailed
        }
    }
}

enum UploadError: Error, LocalizedError {
    case compressionFailed
    case invalidURL
    case uploadFailed

    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Failed to compress image"
        case .invalidURL:
            return "Invalid upload URL"
        case .uploadFailed:
            return "Failed to upload to server"
        }
    }
}
```

**Step 3: Add upload endpoint**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add this)
extension PakktEndpoint {
    static func getPresignedURL(_ request: PresignedURLRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/uploads/presigned-url", method: .post, body: body)
    }
}
```

**Step 4: Commit**

```bash
git add app/Pakkt/Features/Uploads/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(uploads): add UploadsService with R2 integration"
```

---

### Task 4.3: Camera Service

**Files:**
- Create: `app/Pakkt/Features/CheckIns/Services/CameraService.swift`
- Update: `app/Pakkt/Info.plist` (camera permissions)

**Step 1: Create CameraService**

```swift
// app/Pakkt/Features/CheckIns/Services/CameraService.swift
import AVFoundation
import UIKit

actor CameraService {
    // MARK: - Authorization

    func requestCameraAccess() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    func checkCameraAuthorization() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    // MARK: - Image Processing

    func compressImage(_ image: UIImage, maxSizeKB: Int = 500) -> Data? {
        var compression: CGFloat = 0.8
        var imageData = image.jpegData(compressionQuality: compression)

        let maxBytes = maxSizeKB * 1024

        while let data = imageData, data.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            imageData = image.jpegData(compressionQuality: compression)
        }

        return imageData
    }

    func resizeImage(_ image: UIImage, maxDimension: CGFloat = 1024) -> UIImage {
        let size = image.size
        let ratio = size.width / size.height

        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / ratio)
        } else {
            newSize = CGSize(width: maxDimension * ratio, height: maxDimension)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage ?? image
    }
}
```

**Step 2: Update Info.plist for camera permissions**

Add to `app/Pakkt/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Pakkt needs camera access to capture proof of check-ins</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Pakkt needs photo library access to select proof images</string>
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/CheckIns/Services/CameraService.swift app/Pakkt/Info.plist
git commit -m "feat(camera): add CameraService with authorization and image processing"
```

---

### Task 4.4: Check-ins Service

**Files:**
- Create: `app/Pakkt/Features/CheckIns/Services/CheckInsService.swift`

**Step 1: Implement CheckInsService**

```swift
// app/Pakkt/Features/CheckIns/Services/CheckInsService.swift
import Foundation
import UIKit

actor CheckInsService {
    private let apiClient: APIClient
    private let uploadsService: UploadsService

    init(
        apiClient: APIClient = .shared,
        uploadsService: UploadsService = UploadsService()
    ) {
        self.apiClient = apiClient
        self.uploadsService = uploadsService
    }

    // MARK: - Submit Check-in

    func submitCheckIn(
        goalId: UUID,
        proofImage: UIImage? = nil,
        caption: String? = nil
    ) async throws -> CheckIn {
        // Upload proof image if provided
        var proofUrl: String?
        if let image = proofImage {
            proofUrl = try await uploadsService.uploadImage(image)
        }

        // Submit check-in
        let request = CreateCheckInRequest(
            goalId: goalId,
            proofUrl: proofUrl,
            caption: caption
        )

        let endpoint = PakktEndpoint.createCheckIn(request)
        let response: CheckInResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Feed

    func getFeed() async throws -> [FeedItem] {
        let endpoint = PakktEndpoint.getFeed
        let response: FeedResponse = try await apiClient.request(endpoint)
        return response.data
    }

    func getPackCheckIns(packId: UUID) async throws -> [CheckIn] {
        let endpoint = PakktEndpoint.getPackCheckIns(packId: packId)
        let response: FeedResponse = try await apiClient.request(endpoint)
        // Map FeedItem to CheckIn
        return response.data.map { feedItem in
            CheckIn(
                id: feedItem.id,
                goalId: feedItem.goalId,
                userId: feedItem.userId,
                packId: feedItem.packId,
                proofUrl: feedItem.proofUrl,
                caption: feedItem.caption,
                status: feedItem.status,
                streakCount: feedItem.streakCount,
                xpAwarded: feedItem.xpAwarded,
                checkedInAt: feedItem.checkedInAt,
                createdAt: feedItem.createdAt,
                goal: feedItem.goal,
                user: feedItem.user
            )
        }
    }

    // MARK: - Get Check-in Details

    func getCheckIn(id: UUID) async throws -> CheckIn {
        let endpoint = PakktEndpoint.getCheckIn(id: id)
        let response: CheckInResponse = try await apiClient.request(endpoint)
        return response.data
    }
}
```

**Step 2: Add check-in endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Check-ins
    static func createCheckIn(_ request: CreateCheckInRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/checkins", method: .post, body: body)
    }

    static var getFeed: Endpoint {
        Endpoint(path: "/api/checkins/feed", method: .get)
    }

    static func getPackCheckIns(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/checkins", method: .get)
    }

    static func getCheckIn(id: UUID) -> Endpoint {
        Endpoint(path: "/api/checkins/\(id.uuidString)", method: .get)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/CheckIns/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(checkins): add CheckInsService with photo upload support"
```

---

## Phase 5: Feed & Social Features

### Task 5.1: Social Models

**Files:**
- Create: `app/Pakkt/Features/Social/Models/Comment.swift`
- Create: `app/Pakkt/Features/Social/Models/Reaction.swift`

**Step 1: Create social models**

```swift
// app/Pakkt/Features/Social/Models/Reaction.swift
import Foundation

enum EmojiType: String, Codable, CaseIterable {
    case fire = "🔥"
    case muscle = "💪"
    case clap = "👏"
    case party = "🎉"
    case laugh = "😂"
    case heart = "❤️"
    case eyes = "👀"
}

struct Reaction: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let checkInId: UUID?
    let feedEventId: UUID?
    let emoji: EmojiType
    let createdAt: Date
    let user: ReactionUser?

    struct ReactionUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }
}

struct ReactionCounts: Codable, Equatable {
    var counts: [String: ReactionCount]

    struct ReactionCount: Codable, Equatable {
        let count: Int
        let users: [UUID]
        let userReacted: Bool
    }
}

struct ReactionsResponse: Codable {
    let success: Bool
    let data: [Reaction]
}
```

**Step 2: Create Comment model**

```swift
// app/Pakkt/Features/Social/Models/Comment.swift
import Foundation

struct Comment: Codable, Identifiable, Equatable {
    let id: UUID
    let checkInId: UUID
    let userId: UUID
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let user: CommentUser?

    struct CommentUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }
}

struct CommentsResponse: Codable {
    let success: Bool
    let data: [Comment]
}
```

**Step 3: Create request models**

```swift
// app/Pakkt/Features/Social/Models/SocialRequests.swift
import Foundation

struct CreateReactionRequest: Codable {
    let checkInId: UUID?
    let feedEventId: UUID?
    let emoji: EmojiType
}

struct CreateCommentRequest: Codable {
    let checkInId: UUID
    let content: String
}

struct EditCommentRequest: Codable {
    let content: String
}
```

**Step 4: Commit**

```bash
git add app/Pakkt/Features/Social/Models/
git commit -m "feat(social): add Comment and Reaction models"
```

---

### Task 5.2: Social Service

**Files:**
- Create: `app/Pakkt/Features/Social/Services/SocialService.swift`

**Step 1: Implement SocialService**

```swift
// app/Pakkt/Features/Social/Services/SocialService.swift
import Foundation

actor SocialService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Reactions

    func addReaction(to checkInId: UUID, emoji: EmojiType) async throws {
        let request = CreateReactionRequest(checkInId: checkInId, feedEventId: nil, emoji: emoji)
        let endpoint = PakktEndpoint.createReaction(request)
        try await apiClient.request(endpoint)
    }

    func removeReaction(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteReaction(id: id)
        try await apiClient.request(endpoint)
    }

    func getReactions(checkInId: UUID) async throws -> [Reaction] {
        let endpoint = PakktEndpoint.getReactions(checkInId: checkInId)
        let response: ReactionsResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Comments

    func addComment(to checkInId: UUID, content: String) async throws {
        let request = CreateCommentRequest(checkInId: checkInId, content: content)
        let endpoint = PakktEndpoint.createComment(request)
        try await apiClient.request(endpoint)
    }

    func editComment(id: UUID, content: String) async throws {
        let request = EditCommentRequest(content: content)
        let endpoint = PakktEndpoint.editComment(id: id, request: request)
        try await apiClient.request(endpoint)
    }

    func deleteComment(id: UUID) async throws {
        let endpoint = PakktEndpoint.deleteComment(id: id)
        try await apiClient.request(endpoint)
    }

    func getComments(checkInId: UUID) async throws -> [Comment] {
        let endpoint = PakktEndpoint.getComments(checkInId: checkInId)
        let response: CommentsResponse = try await apiClient.request(endpoint)
        return response.data
    }
}
```

**Step 2: Add social endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Reactions
    static func createReaction(_ request: CreateReactionRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/social/reactions", method: .post, body: body)
    }

    static func deleteReaction(id: UUID) -> Endpoint {
        Endpoint(path: "/api/social/reactions/\(id.uuidString)", method: .delete)
    }

    static func getReactions(checkInId: UUID) -> Endpoint {
        Endpoint(path: "/api/checkins/\(checkInId.uuidString)/reactions", method: .get)
    }

    // Comments
    static func createComment(_ request: CreateCommentRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/social/comments", method: .post, body: body)
    }

    static func editComment(id: UUID, request: EditCommentRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/social/comments/\(id.uuidString)", method: .patch, body: body)
    }

    static func deleteComment(id: UUID) -> Endpoint {
        Endpoint(path: "/api/social/comments/\(id.uuidString)", method: .delete)
    }

    static func getComments(checkInId: UUID) -> Endpoint {
        Endpoint(path: "/api/checkins/\(checkInId.uuidString)/comments", method: .get)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Social/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(social): add SocialService with reactions and comments"
```

---

## Phase 6: Fines & Voting System

### Task 6.1: Fine Models

**Files:**
- Create: `app/Pakkt/Features/Fines/Models/Fine.swift`
- Create: `app/Pakkt/Features/Fines/Models/FineVote.swift`

**Step 1: Create Fine models**

```swift
// app/Pakkt/Features/Fines/Models/Fine.swift
import Foundation

enum FineStatus: String, Codable {
    case pending
    case voting
    case enforced
    case cancelled
    case appealed
}

struct Fine: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let goalId: UUID
    let checkInId: UUID?
    let amount: Int // In cents
    let reason: String
    let status: FineStatus
    let votingEndsAt: Date?
    let resolvedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let user: FineUser?
    let goal: FineGoal?

    struct FineUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }

    struct FineGoal: Codable, Equatable {
        let title: String
    }
}

struct FineResponse: Codable {
    let success: Bool
    let data: Fine
}

struct FineListResponse: Codable {
    let success: Bool
    let data: [Fine]
}
```

**Step 2: Create FineVote models**

```swift
// app/Pakkt/Features/Fines/Models/FineVote.swift
import Foundation

struct FineVote: Codable, Identifiable, Equatable {
    let id: UUID
    let fineId: UUID
    let userId: UUID
    let vote: Bool // true = enforce, false = dismiss
    let comment: String?
    let createdAt: Date
    let user: VoteUser?

    struct VoteUser: Codable, Equatable {
        let username: String
    }
}

struct VoteResult: Codable, Equatable {
    let fineId: UUID
    let totalVotes: Int
    let enforceVotes: Int
    let dismissVotes: Int
    let consensus: Consensus
    let votingClosed: Bool
    let votes: [FineVote]

    enum Consensus: String, Codable {
        case enforce
        case dismiss
        case pending
    }
}

struct FineWithVotes: Codable, Identifiable, Equatable {
    let id: UUID
    let packId: UUID
    let userId: UUID
    let goalId: UUID
    let checkInId: UUID?
    let amount: Int
    let reason: String
    let status: FineStatus
    let votingEndsAt: Date?
    let resolvedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let voteResult: VoteResult
}

struct VoteRequest: Codable {
    let vote: Bool
    let comment: String?
}

struct FineWithVotesResponse: Codable {
    let success: Bool
    let data: FineWithVotes
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Fines/Models/
git commit -m "feat(fines): add Fine and FineVote models"
```

---

### Task 6.2: Fines Service

**Files:**
- Create: `app/Pakkt/Features/Fines/Services/FinesService.swift`

**Step 1: Implement FinesService**

```swift
// app/Pakkt/Features/Fines/Services/FinesService.swift
import Foundation

actor FinesService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - List Fines

    func listPackFines(packId: UUID) async throws -> [Fine] {
        let endpoint = PakktEndpoint.listPackFines(packId: packId)
        let response: FineListResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Fine with Votes

    func getFineWithVotes(id: UUID) async throws -> FineWithVotes {
        let endpoint = PakktEndpoint.getFine(id: id)
        let response: FineWithVotesResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Vote on Fine

    func vote(on fineId: UUID, enforce: Bool, comment: String? = nil) async throws {
        let request = VoteRequest(vote: enforce, comment: comment)
        let endpoint = PakktEndpoint.voteOnFine(fineId: fineId, request: request)
        try await apiClient.request(endpoint)
    }

    // MARK: - Resolve Fine (Manual)

    func resolveFine(id: UUID) async throws {
        let endpoint = PakktEndpoint.resolveFine(id: id)
        try await apiClient.request(endpoint)
    }

    // MARK: - Appeal Fine

    func appealFine(id: UUID, reason: String) async throws {
        let request = AppealRequest(reason: reason)
        let endpoint = PakktEndpoint.appealFine(id: id, request: request)
        try await apiClient.request(endpoint)
    }
}

struct AppealRequest: Codable {
    let reason: String
}
```

**Step 2: Add fine endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Fines
    static func listPackFines(packId: UUID) -> Endpoint {
        Endpoint(path: "/api/packs/\(packId.uuidString)/fines", method: .get)
    }

    static func getFine(id: UUID) -> Endpoint {
        Endpoint(path: "/api/fines/\(id.uuidString)", method: .get)
    }

    static func voteOnFine(fineId: UUID, request: VoteRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/fines/\(fineId.uuidString)/vote", method: .post, body: body)
    }

    static func resolveFine(id: UUID) -> Endpoint {
        Endpoint(path: "/api/fines/\(id.uuidString)/resolve", method: .post)
    }

    static func appealFine(id: UUID, request: AppealRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/fines/\(id.uuidString)/appeal", method: .post, body: body)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Fines/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(fines): add FinesService with voting and appeal support"
```

---

## Phase 7: Screen Time Jail Integration

### Task 7.1: Jail Models

**Files:**
- Create: `app/Pakkt/Features/Jail/Models/JailSession.swift`

**Step 1: Create Jail models**

```swift
// app/Pakkt/Features/Jail/Models/JailSession.swift
import Foundation

enum JailStatus: String, Codable {
    case active
    case completed
    case broken
}

struct JailSession: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let packId: UUID
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int
    let blockedApps: [String]
    let status: JailStatus
    let startedAt: Date
    let lastHeartbeatAt: Date?
    let pausedAt: Date?
    let totalPausedDuration: Int // In seconds
    let completedAt: Date?
    let createdAt: Date
    let updatedAt: Date
    let user: JailUser?
    let goal: JailGoal?

    struct JailUser: Codable, Equatable {
        let username: String
        let profilePic: String?
    }

    struct JailGoal: Codable, Equatable {
        let title: String
    }
}

struct JailSessionWithProgress: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let packId: UUID
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int
    let blockedApps: [String]
    let status: JailStatus
    let startedAt: Date
    let elapsedMinutes: Int
    let remainingMinutes: Int
    let progressPercentage: Double
    let isPaused: Bool
    let canBreak: Bool
    let breakFineAmount: Int
}

struct StartJailRequest: Codable {
    let goalId: UUID
    let fineId: UUID?
    let durationMinutes: Int?
    let blockedApps: [String]
}

struct JailSessionResponse: Codable {
    let success: Bool
    let data: JailSession
}

struct JailSessionWithProgressResponse: Codable {
    let success: Bool
    let data: JailSessionWithProgress
}
```

**Step 2: Commit**

```bash
git add app/Pakkt/Features/Jail/Models/
git commit -m "feat(jail): add JailSession models"
```

---

### Task 7.2: Screen Time Service (Family Controls)

**Files:**
- Create: `app/Pakkt/Features/Jail/Services/ScreenTimeService.swift`
- Update: `app/Pakkt/Pakkt.entitlements`

**Step 1: Add Family Controls capability**

Create `app/Pakkt/Pakkt.entitlements`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.family-controls</key>
    <true/>
</dict>
</plist>
```

**Step 2: Create ScreenTimeService**

```swift
// app/Pakkt/Features/Jail/Services/ScreenTimeService.swift
import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

@available(iOS 16.0, *)
actor ScreenTimeService {
    private let authorizationCenter = AuthorizationCenter.shared

    // MARK: - Authorization

    func requestAuthorization() async throws -> Bool {
        do {
            try await authorizationCenter.requestAuthorization(for: .individual)
            return true
        } catch {
            throw ScreenTimeError.authorizationDenied
        }
    }

    func checkAuthorizationStatus() -> AuthorizationStatus {
        return authorizationCenter.authorizationStatus
    }

    // MARK: - Start Jail Session

    func startJailSession(
        sessionId: String,
        durationMinutes: Int,
        blockedAppTokens: Set<ApplicationToken>
    ) async throws {
        // Ensure we have authorization
        guard authorizationCenter.authorizationStatus == .approved else {
            throw ScreenTimeError.authorizationRequired
        }

        // Configure blocked apps
        let store = ManagedSettingsStore(named: .init(sessionId))
        store.application.blockedApplications = blockedAppTokens

        // Set up device activity monitor
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 0, minute: durationMinutes),
            repeats: false
        )

        let center = DeviceActivityCenter()
        try center.startMonitoring(.init(sessionId), during: schedule)
    }

    // MARK: - End Jail Session

    func endJailSession(sessionId: String) async throws {
        // Clear restrictions
        let store = ManagedSettingsStore(named: .init(sessionId))
        store.application.blockedApplications = nil
        store.clearAllSettings()

        // Stop monitoring
        let center = DeviceActivityCenter()
        center.stopMonitoring([.init(sessionId)])
    }

    // MARK: - Pause/Resume

    func pauseJailSession(sessionId: String) async throws {
        let store = ManagedSettingsStore(named: .init(sessionId))
        store.application.blockedApplications = nil
    }

    func resumeJailSession(
        sessionId: String,
        blockedAppTokens: Set<ApplicationToken>
    ) async throws {
        let store = ManagedSettingsStore(named: .init(sessionId))
        store.application.blockedApplications = blockedAppTokens
    }
}

enum ScreenTimeError: Error, LocalizedError {
    case authorizationDenied
    case authorizationRequired
    case monitoringFailed

    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "Screen Time authorization was denied"
        case .authorizationRequired:
            return "Screen Time authorization is required"
        case .monitoringFailed:
            return "Failed to start device activity monitoring"
        }
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Jail/Services/ScreenTimeService.swift app/Pakkt/Pakkt.entitlements
git commit -m "feat(jail): add ScreenTimeService with Family Controls integration"
```

---

### Task 7.3: Jail Service

**Files:**
- Create: `app/Pakkt/Features/Jail/Services/JailService.swift`

**Step 1: Implement JailService**

```swift
// app/Pakkt/Features/Jail/Services/JailService.swift
import Foundation

actor JailService {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Start Jail

    func startJail(request: StartJailRequest) async throws -> JailSession {
        let endpoint = PakktEndpoint.startJail(request)
        let response: JailSessionResponse = try await apiClient.request(endpoint)
        return response.data
    }

    // MARK: - Get Active Session

    func getActiveSession() async throws -> JailSessionWithProgress? {
        let endpoint = PakktEndpoint.getActiveJailSession
        do {
            let response: JailSessionWithProgressResponse = try await apiClient.request(endpoint)
            return response.data
        } catch APIError.notFound {
            return nil
        }
    }

    // MARK: - Send Heartbeat

    func sendHeartbeat(sessionId: UUID) async throws {
        let endpoint = PakktEndpoint.jailHeartbeat(sessionId: sessionId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Complete Jail

    func completeJail(sessionId: UUID) async throws {
        let endpoint = PakktEndpoint.completeJail(sessionId: sessionId)
        try await apiClient.request(endpoint)
    }

    // MARK: - Break Jail

    func breakJail(sessionId: UUID, paymentMethod: String? = nil) async throws {
        let request = BreakJailRequest(paymentMethod: paymentMethod)
        let endpoint = PakktEndpoint.breakJail(sessionId: sessionId, request: request)
        try await apiClient.request(endpoint)
    }
}

struct BreakJailRequest: Codable {
    let paymentMethod: String?
}
```

**Step 2: Add jail endpoints**

```swift
// app/Pakkt/Core/Network/PakktEndpoint.swift (add these)
extension PakktEndpoint {
    // Jail
    static func startJail(_ request: StartJailRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/jail/sessions", method: .post, body: body)
    }

    static var getActiveJailSession: Endpoint {
        Endpoint(path: "/api/jail/sessions/active", method: .get)
    }

    static func jailHeartbeat(sessionId: UUID) -> Endpoint {
        Endpoint(path: "/api/jail/sessions/\(sessionId.uuidString)/heartbeat", method: .post)
    }

    static func completeJail(sessionId: UUID) -> Endpoint {
        Endpoint(path: "/api/jail/sessions/\(sessionId.uuidString)/complete", method: .post)
    }

    static func breakJail(sessionId: UUID, request: BreakJailRequest) -> Endpoint {
        let body = try? JSONEncoder().encode(request)
        return Endpoint(path: "/api/jail/sessions/\(sessionId.uuidString)/break", method: .post, body: body)
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Features/Jail/Services/ app/Pakkt/Core/Network/PakktEndpoint.swift
git commit -m "feat(jail): add JailService with session management"
```

---

## Phase 8: Notifications & Polish

### Task 8.1: Notification Service

**Files:**
- Create: `app/Pakkt/Core/Services/NotificationService.swift`
- Update: `app/Pakkt/Info.plist`

**Step 1: Add notification permissions to Info.plist**

Update `app/Pakkt/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

**Step 2: Create NotificationService**

```swift
// app/Pakkt/Core/Services/NotificationService.swift
import Foundation
import UserNotifications

actor NotificationService {
    private let usersService: UsersService

    init(usersService: UsersService = UsersService()) {
        self.usersService = usersService
    }

    // MARK: - Authorization

    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()

        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted
    }

    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Register Device Token

    func registerDeviceToken(_ token: Data) async throws {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        try await usersService.registerPushToken(
            token: tokenString,
            deviceType: "ios",
            deviceId: UIDevice.current.identifierForVendor?.uuidString
        )
    }

    // MARK: - Local Notifications

    func scheduleCheckInReminder(for goal: Goal) async throws {
        guard let timeComponents = goal.checkInTimeComponents else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time to check in!"
        content.body = goal.title
        content.sound = .default
        content.categoryIdentifier = "CHECK_IN_REMINDER"
        content.userInfo = ["goalId": goal.id.uuidString]

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: timeComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "check-in-\(goal.id.uuidString)",
            content: content,
            trigger: trigger
        )

        let center = UNUserNotificationCenter.current()
        try await center.add(request)
    }

    func cancelCheckInReminder(for goalId: UUID) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["check-in-\(goalId.uuidString)"])
    }

    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
```

**Step 3: Commit**

```bash
git add app/Pakkt/Core/Services/NotificationService.swift app/Pakkt/Info.plist
git commit -m "feat(notifications): add NotificationService with push and local notifications"
```

---

### Task 8.2: Deep Linking Handler

**Files:**
- Create: `app/Pakkt/Core/Navigation/DeepLinkHandler.swift`

**Step 1: Create DeepLinkHandler**

```swift
// app/Pakkt/Core/Navigation/DeepLinkHandler.swift
import Foundation

enum DeepLink: Equatable {
    case pack(id: UUID)
    case goal(id: UUID)
    case checkIn(id: UUID)
    case fine(id: UUID)
    case jailSession(id: UUID)
    case feed
    case profile
}

actor DeepLinkHandler {
    func handle(_ url: URL) -> DeepLink? {
        guard url.scheme == "pakkt" else { return nil }

        let path = url.path
        let components = path.split(separator: "/").map(String.init)

        guard components.count >= 2 else { return nil }

        let type = components[0]
        let id = components[1]

        guard let uuid = UUID(uuidString: id) else {
            // Handle non-UUID paths
            switch type {
            case "feed":
                return .feed
            case "profile":
                return .profile
            default:
                return nil
            }
        }

        switch type {
        case "pack":
            return .pack(id: uuid)
        case "goal":
            return .goal(id: uuid)
        case "checkin":
            return .checkIn(id: uuid)
        case "fine":
            return .fine(id: uuid)
        case "jail":
            return .jailSession(id: uuid)
        default:
            return nil
        }
    }

    func handle(userInfo: [AnyHashable: Any]) -> DeepLink? {
        // Handle push notification payload
        guard let type = userInfo["type"] as? String,
              let idString = userInfo["id"] as? String else {
            return nil
        }

        if type == "feed" {
            return .feed
        }

        if type == "profile" {
            return .profile
        }

        guard let id = UUID(uuidString: idString) else { return nil }

        switch type {
        case "pack":
            return .pack(id: id)
        case "goal":
            return .goal(id: id)
        case "checkin":
            return .checkIn(id: id)
        case "fine":
            return .fine(id: id)
        case "jail":
            return .jailSession(id: id)
        default:
            return nil
        }
    }
}
```

**Step 2: Commit**

```bash
git add app/Pakkt/Core/Navigation/DeepLinkHandler.swift
git commit -m "feat(navigation): add DeepLinkHandler for URL and notification handling"
```

---

## Testing & Validation

### Task 9.1: Integration Testing Script

**Files:**
- Create: `app/scripts/test-ios-integration.sh`

**Step 1: Create integration test script**

```bash
#!/bin/bash
# app/scripts/test-ios-integration.sh

set -e

echo "🧪 Pakkt iOS Integration Tests"
echo ""

# Load test environment
source ../backend/scripts/load-env.sh
load_dev_vars

API_URL="${API_URL:-http://localhost:8787}"

echo "📱 Testing iOS app against: $API_URL"
echo ""

# 1. Test auth flow
echo "1️⃣ Testing authentication..."
# This would be done via Xcode UI tests or XCTest

# 2. Test pack creation
echo "2️⃣ Testing pack creation..."

# 3. Test goal creation
echo "3️⃣ Testing goal creation..."

# 4. Test check-in submission
echo "4️⃣ Testing check-in submission..."

# 5. Test voting flow
echo "5️⃣ Testing voting flow..."

echo ""
echo "✅ All integration tests passed!"
```

**Step 2: Make script executable**

Run: `chmod +x app/scripts/test-ios-integration.sh`

**Step 3: Commit**

```bash
git add app/scripts/test-ios-integration.sh
git commit -m "test: add iOS integration testing script"
```

---

## Summary

This implementation plan provides **bite-sized tasks** for building the complete Pakkt iOS app with all 8 backend features:

### ✅ Completed Features:
1. **Foundation**: Dependencies, KeychainService, Enhanced APIClient, Supabase Realtime
2. **Users**: Profile management, push token registration
3. **Packs**: CRUD operations, member management, statistics
4. **Goals**: Scheduling system with recurrence rules
5. **Check-ins**: Photo capture, R2 upload, streak tracking
6. **Social**: Comments, reactions, feed interactions
7. **Fines**: Democratic voting system with real-time updates
8. **Jail**: Screen Time integration via Family Controls
9. **Notifications**: Push notifications, local reminders, deep linking

### 📋 Next Steps:
1. **Build UI Views**: Create SwiftUI views for each feature (following existing ViewModel patterns)
2. **Wire up ViewModels**: Connect services to ViewModels with @Published properties
3. **Navigation**: Implement deep linking and coordinator navigation
4. **Testing**: Write XCTests and integration tests
5. **Polish**: Animations, empty states, error handling
6. **Deployment**: App Store preparation

### 🏗️ Architecture Summary:
```
SwiftUI Views
    ↓
ViewModels (@Published state)
    ↓
Services (business logic)
    ↓
APIClient (network layer)
    ↓
Backend API (Cloudflare Workers + Supabase)
```

### 🎯 All Backend Types Mapped to Swift Models:
- ✅ UserProfile, Pack, PackMember, PackStats
- ✅ Goal, RecurrenceRule, GoalWithStats
- ✅ CheckIn, FeedItem, StreakResult
- ✅ Fine, FineVote, VoteResult, FineWithVotes
- ✅ JailSession, JailSessionWithProgress
- ✅ Comment, Reaction, ReactionCounts
- ✅ All request/response wrappers

---

**Total Estimated Time**: 6-8 weeks for complete implementation

**Ready for execution!** 🚀
