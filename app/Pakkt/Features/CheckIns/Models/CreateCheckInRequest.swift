import Foundation

struct CreateCheckInRequest: Codable, Sendable {
    let goalId: UUID
    let proofUrl: String?
    let caption: String?

    init(goalId: UUID, proofUrl: String? = nil, caption: String? = nil) {
        self.goalId = goalId
        self.proofUrl = proofUrl
        self.caption = caption
    }
}
