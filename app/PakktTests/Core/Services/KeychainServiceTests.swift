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

    func testGetAuthTokenWhenNoneExists() throws {
        // Given - no token saved

        // When
        let token = try sut.getAuthToken()

        // Then
        XCTAssertNil(token)
    }

    func testSaveRefreshToken() throws {
        // Given
        let refreshToken = "test-refresh-token-67890"

        // When
        try sut.saveRefreshToken(refreshToken)
        let retrieved = try sut.getRefreshToken()

        // Then
        XCTAssertEqual(retrieved, refreshToken)
    }

    func testClearAll() throws {
        // Given
        try sut.saveAuthToken("auth-token")
        try sut.saveRefreshToken("refresh-token")

        // When
        try sut.clearAll()

        // Then
        XCTAssertNil(try? sut.getAuthToken())
        XCTAssertNil(try? sut.getRefreshToken())
    }
}
