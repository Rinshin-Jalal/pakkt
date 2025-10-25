// app/Pakkt/Core/Services/UserSettingsService.swift
import Foundation
import UserNotifications
import Combine

@MainActor
class UserSettingsService: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    @Published var dailyReminderEnabled: Bool = true
    @Published var checkInNotificationsEnabled: Bool = true
    @Published var fineNotificationsEnabled: Bool = true
    
    private let notificationService: NotificationService
    private let usersService: UsersService

    nonisolated init(notificationService: NotificationService = NotificationService(),
                     usersService: UsersService = UsersService()) {
        self.notificationService = notificationService
        self.usersService = usersService

        // Note: loadSettings() will be called separately on main actor
    }
    
    func loadSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: "dailyReminderEnabled")
        checkInNotificationsEnabled = UserDefaults.standard.bool(forKey: "checkInNotificationsEnabled")
        fineNotificationsEnabled = UserDefaults.standard.bool(forKey: "fineNotificationsEnabled")
        
        // If notifications were never configured, default to enabled
        if !UserDefaults.standard.bool(forKey: "settingsInitialized") {
            notificationsEnabled = true
            dailyReminderEnabled = true
            checkInNotificationsEnabled = true
            fineNotificationsEnabled = true
            saveSettings()
            UserDefaults.standard.set(true, forKey: "settingsInitialized")
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(dailyReminderEnabled, forKey: "dailyReminderEnabled")
        UserDefaults.standard.set(checkInNotificationsEnabled, forKey: "checkInNotificationsEnabled")
        UserDefaults.standard.set(fineNotificationsEnabled, forKey: "fineNotificationsEnabled")
    }
    
    // MARK: - Toggle Notification Settings
    
    func toggleNotifications(_ enabled: Bool) async throws {
        if enabled {
            // Re-enable notifications
            let permissionGranted = try await notificationService.requestAuthorization()
            if permissionGranted {
                notificationsEnabled = true
            } else {
                throw NSError(domain: "NotificationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission denied"])
            }
        } else {
            // Disable notifications by unregistering the token
            try await notificationService.unregisterDeviceToken()
            notificationsEnabled = false
        }
        
        saveSettings()
    }
    
    func toggleDailyReminder(_ enabled: Bool) {
        dailyReminderEnabled = enabled
        saveSettings()
    }
    
    func toggleCheckInNotifications(_ enabled: Bool) {
        checkInNotificationsEnabled = enabled
        saveSettings()
    }
    
    func toggleFineNotifications(_ enabled: Bool) {
        fineNotificationsEnabled = enabled
        saveSettings()
    }
    
    // MARK: - Check Notification Permissions
    
    func getNotificationStatus() async -> UNAuthorizationStatus {
        return await notificationService.checkAuthorizationStatus()
    }
    
    func areNotificationsAllowed() async -> Bool {
        let status = await getNotificationStatus()
        return status == .authorized || status == .provisional
    }
}