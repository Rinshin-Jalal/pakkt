// app/Pakkt/Features/Profile/Views/NotificationSettingsView.swift
import SwiftUI

struct NotificationSettingsView: View {
    @StateObject var viewModel = NotificationSettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Push Notifications") {
                    Toggle("Enable Notifications", isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { _ in Task { await viewModel.toggleAllNotifications() } }
                    ))
                    .onChange(of: viewModel.notificationsEnabled) { _ in
                        // Update the toggle state based on the service
                    }
                }
                
                if viewModel.notificationsEnabled {
                    Section("Notification Types") {
                        Toggle("Daily Reminders", isOn: Binding(
                            get: { viewModel.dailyReminderEnabled },
                            set: { _ in Task { await viewModel.toggleDailyReminder() } }
                        ))

                        Toggle("Check-in Notifications", isOn: Binding(
                            get: { viewModel.checkInNotificationsEnabled },
                            set: { _ in Task { await viewModel.toggleCheckInNotifications() } }
                        ))

                        Toggle("Fine Notifications", isOn: Binding(
                            get: { viewModel.fineNotificationsEnabled },
                            set: { _ in Task { await viewModel.toggleFineNotifications() } }
                        ))
                    }
                }
                
                Section("Permissions") {
                    Button("Open Settings") {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .overlay(
                Group {
                    if viewModel.isUpdating {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
            )
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}