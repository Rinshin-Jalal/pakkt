import Foundation
import UIKit

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
