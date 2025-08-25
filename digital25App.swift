import SwiftUI

@main
struct Digital25App: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(settings)
                .preferredColorScheme(settings.selectedTheme.colorScheme)
        }
    }
}
