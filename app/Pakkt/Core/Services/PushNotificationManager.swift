import Foundation
import UIKit
import UserNotifications
import SwiftUI

// MARK: - PushNotificationManager
class PushNotificationManager: NSObject, ObservableObject {
    static let shared = PushNotificationManager()
    
    @Published var notificationService: NotificationService
    @Published var deepLinkHandler: DeepLinkHandler
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
        print("Failed to get device token: $error)")
    }
    
    // MARK: - Handle Notifications
    
    @MainActor
    func handleNotification(userInfo: [AnyHashable: Any], isForeground: Bool = false) {
        print("Handling notification with userInfo: $userInfo)")
        
        // Extract title and body from notification
        let title = userInfo["title"] as? String ?? userInfo["aps"]?["alert"]?["title"] as? String
        let body = userInfo["body"] as? String ?? userInfo["aps"]?["alert"]?["body"] as? String
        let badge = userInfo["badge"] as? Int ?? userInfo["aps"]?["badge"] as? Int
        
        // Update badge count if present
        if let badge = badge {
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = badge
            }
        }
        
        // Handle deep linking
        if let deepLink = deepLinkHandler.handle(userInfo: userInfo) {
            print("Deep link found: $deepLink)")
            
            // Navigate to the appropriate screen if coordinator is available
            if let coordinator = appCoordinator {
                coordinator.handleDeepLink(deepLink)
            } else {
                print("App coordinator not set, cannot handle deep link")
            }
        }
        
        // If the app is in foreground, we might want to show an in-app notification
        // rather than the system notification
        if isForeground {
            // Show in-app notification or alert
            print("Notification received in foreground: $title ?? "Unknown")")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
    // Called when a notification is received while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("Received notification while in foreground: $(notification.request.content.title)")
        
        // Show the notification even when app is in foreground
        // You can return [.banner, .sound, .badge] to show the notification
        // or return [] to handle it yourself
        return [.banner, .sound, .badge]
    }
    
    // Called when user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("User tapped notification: $(response.notification.request.content.title)")
        
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo, isForeground: false)
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