import Foundation

enum GoalType: String, Codable, Sendable {
    case personal
    case pack
}

struct CreateGoalRequest: Codable, Sendable {
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

    enum CodingKeys: String, CodingKey {
        case title, description, checkInTime, recurrenceRule, goalType, assignedToUserId, fineAmount, jailDuration, proofRequired, baseXp
    }

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

struct UpdateGoalRequest: Codable, Sendable {
    let title: String?
    let description: String?
    let checkInTime: String?
    let recurrenceRule: RecurrenceRule?
    let fineAmount: Int?
    let jailDuration: Int?
    let proofRequired: Bool?
    let baseXp: Int?
}
