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
