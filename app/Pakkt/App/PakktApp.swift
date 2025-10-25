import SwiftUI
import UIKit

@main
struct PakktApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var pushNotificationManager = PushNotificationManager.shared
    @StateObject private var realtimeFeedManager = RealtimeFeedManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .onAppear {
                    // Set the coordinator in the push notification manager for deep linking
                    pushNotificationManager.setAppCoordinator(coordinator)

                    // Request notification permission on app launch
                    Task {
                        let permissionGranted = await pushNotificationManager.requestPermission()
                        if permissionGranted {
                            // Register for remote push notifications
                            pushNotificationManager.registerForPushNotifications()
                        }
                    }
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.didBecomeActiveNotification
                    )
                ) { _ in
                    // Update the badge count when app becomes active
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    // Handle app becoming active for real-time updates
                    Task {
                        await realtimeFeedManager.handleAppWillEnterForeground()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    // Handle app going to background for real-time updates
                    Task {
                        await realtimeFeedManager.handleAppDidEnterBackground()
                    }
                }
        }
    }
}
