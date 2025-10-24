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