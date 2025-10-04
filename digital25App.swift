import SwiftUI
import UserNotifications

@main
struct Digital25App: App {
    // ✅ Create a single shared instance
    @StateObject var appSettings = AppSettings()

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            // ✅ Pass it to the root view
            DashboardView()
                .environmentObject(appSettings)
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
