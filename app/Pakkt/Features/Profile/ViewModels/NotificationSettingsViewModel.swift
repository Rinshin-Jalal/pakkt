// app/Pakkt/Features/Profile/ViewModels/NotificationSettingsViewModel.swift
import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationSettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    @Published var dailyReminderEnabled: Bool = true
    @Published var checkInNotificationsEnabled: Bool = true
    @Published var fineNotificationsEnabled: Bool = true
    @Published var isUpdating: Bool = false
    @Published var errorMessage: String?
    
    private let userSettingsService: UserSettingsService
    private let notificationService: NotificationService
    
    init(userSettingsService: UserSettingsService = UserSettingsService(),
         notificationService: NotificationService = NotificationService()) {
        self.userSettingsService = userSettingsService
        self.notificationService = notificationService
        
        loadSettings()
    }
    
    private func loadSettings() {
        notificationsEnabled = userSettingsService.notificationsEnabled
        dailyReminderEnabled = userSettingsService.dailyReminderEnabled
        checkInNotificationsEnabled = userSettingsService.checkInNotificationsEnabled
        fineNotificationsEnabled = userSettingsService.fineNotificationsEnabled
    }
    
    func toggleAllNotifications() async {
        guard !isUpdating else { return }
        
        isUpdating = true
        errorMessage = nil
        
        do {
            // Toggle the setting in the service
            try await userSettingsService.toggleNotifications(!notificationsEnabled)
            
            // Update the local state
            notificationsEnabled = !notificationsEnabled
            
            // If disabling notifications, also update related settings
            if !notificationsEnabled {
                dailyReminderEnabled = false
                checkInNotificationsEnabled = false
                fineNotificationsEnabled = false
            }
        } catch {
            errorMessage = error.localizedDescription
            // Revert the toggle since it failed
            notificationsEnabled = !notificationsEnabled
        }
        
        isUpdating = false
    }
    
    func toggleDailyReminder() async {
        guard !isUpdating else { return }
        
        isUpdating = true
        userSettingsService.toggleDailyReminder(!dailyReminderEnabled)
        dailyReminderEnabled = !dailyReminderEnabled
        isUpdating = false
    }
    
    func toggleCheckInNotifications() async {
        guard !isUpdating else { return }
        
        isUpdating = true
        userSettingsService.toggleCheckInNotifications(!checkInNotificationsEnabled)
        checkInNotificationsEnabled = !checkInNotificationsEnabled
        isUpdating = false
    }
    
    func toggleFineNotifications() async {
        guard !isUpdating else { return }
        
        isUpdating = true
        userSettingsService.toggleFineNotifications(!fineNotificationsEnabled)
        fineNotificationsEnabled = !fineNotificationsEnabled
        isUpdating = false
    }
    
    func checkNotificationPermission() async {
        let status = await notificationService.checkAuthorizationStatus()
        notificationsEnabled = (status == .authorized || status == .provisional)
    }
}