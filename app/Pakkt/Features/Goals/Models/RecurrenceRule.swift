import Foundation

enum RecurrenceType: String, Codable, Sendable {
    case daily
    case weekly
    case custom
}

struct RecurrenceRule: Codable, Equatable, Sendable {
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
