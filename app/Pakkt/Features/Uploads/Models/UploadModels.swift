import Foundation

struct PresignedURLRequest: Codable, Sendable {
    let filename: String
    let contentType: String

    init(filename: String, contentType: String = "image/jpeg") {
        self.filename = filename
        self.contentType = contentType
    }
}

struct PresignedURLResponse: Codable, Sendable {
    let success: Bool
    let data: PresignedURLData

    struct PresignedURLData: Codable, Sendable {
        let uploadUrl: String
        let publicUrl: String
    }
}
