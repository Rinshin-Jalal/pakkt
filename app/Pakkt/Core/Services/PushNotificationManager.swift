import Foundation
import UIKit
import UserNotifications
import SwiftUI
import Combine

// MARK: - PushNotificationManager
@MainActor
class PushNotificationManager: NSObject, ObservableObject {
    static let shared = PushNotificationManager()

    let objectWillChange = ObservableObjectPublisher()

    private let notificationService: NotificationService
    private let deepLinkHandler: DeepLinkHandler
    weak var appCoordinator: AppCoordinator?

    private override init() {
        self.notificationService = NotificationService()
        self.deepLinkHandler = DeepLinkHandler()
        super.init()

        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Request Permission
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationService.requestAuthorization()
            print("Notification permission granted: $granted)")
            return granted
        } catch {
            print("Error requesting notification permission: $error)")
            return false
        }
    }
    
    // MARK: - Register for Push Notifications
    
    func registerForPushNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: - Set Coordinator for Navigation
    
    func setAppCoordinator(_ coordinator: AppCoordinator) {
        self.appCoordinator = coordinator
    }
    
    // MARK: - Handle Device Token
    
    func handleDeviceToken(_ token: Data) {
        Task {
            do {
                try await notificationService.registerDeviceToken(token)
                print("Successfully registered device token with backend")
            } catch {
                print("Error registering device token: $error)")
            }
        }
    }
    
    func handleDeviceTokenError(_ error: Error) {
//        print("Failed to get device token: $error)")
    }
    
    // MARK: - Handle Notifications

    func handleNotification(userInfo: [AnyHashable: Any], isForeground: Bool = false) {
        print("📩 [Push] Handling notification")
        print("📩 [Push] UserInfo: \(userInfo)")
        print("📩 [Push] Is Foreground: \(isForeground)")

        // Extract title and body from notification
        let title = userInfo["title"] as? String ?? (userInfo["aps"] as? [String: Any])?["alert"] as? String
        let body = userInfo["body"] as? String ?? (userInfo["aps"] as? [String: Any])?["alert"] as? String
        let badge = userInfo["badge"] as? Int ?? (userInfo["aps"] as? [String: Any])?["badge"] as? Int

        print("📩 [Push] Title: \(title ?? "nil")")
        print("📩 [Push] Body: \(body ?? "nil")")

        // Update badge count if present
        if let badge = badge {
            print("📩 [Push] Updating badge to: \(badge)")
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = badge
            }
        }

        // Handle deep linking
        Task {
            if let deepLink = await deepLinkHandler.handle(userInfo: userInfo) {
                print("🔗 [DeepLink] Found: \(deepLink)")

                // Navigate to the appropriate screen if coordinator is available
                if let coordinator = appCoordinator {
                    print("🔗 [DeepLink] Navigating via coordinator")
                    coordinator.handleDeepLink(deepLink)
                } else {
                    print("⚠️ [DeepLink] App coordinator not set, cannot navigate")
                }
            } else {
                print("⚠️ [DeepLink] No deep link found in notification")
            }
        }

        // If the app is in foreground, we might want to show an in-app notification
        // rather than the system notification
        if isForeground {
            // Show in-app notification or alert
            print("📱 [Push] Notification received in foreground: \(title ?? "Unknown")")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    // Called when a notification is received while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("📱 [Push] Received notification in FOREGROUND")
        print("📱 [Push] Title: \(notification.request.content.title)")
        print("📱 [Push] Body: \(notification.request.content.body)")

        // Handle the notification (for deep linking if needed)
        await handleNotification(userInfo: notification.request.content.userInfo, isForeground: true)

        // Show the notification even when app is in foreground
        // Return [.banner, .sound, .badge] to show the notification
        // or return [] to handle it yourself
        return [.banner, .sound, .badge]
    }

    // Called when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("👆 [Push] User TAPPED notification")
        print("👆 [Push] Title: \(response.notification.request.content.title)")
        print("👆 [Push] Body: \(response.notification.request.content.body)")

        let userInfo = response.notification.request.content.userInfo
        await handleNotification(userInfo: userInfo, isForeground: false)
    }
}

// MARK: - UIApplicationDelegate methods for token handling

// This will need to be called from the app delegate or scene delegate
extension PushNotificationManager {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        handleDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        handleDeviceTokenError(error)
    }
}
