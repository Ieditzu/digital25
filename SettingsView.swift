import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $settings.selectedTheme) {
                    ForEach(Theme.allCases) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
            }
            
            Section(header: Text("Units")) {
                Picker("Temperature Unit", selection: $settings.temperatureUnit) {
                    ForEach(TemperatureUnit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
            }
            
            Section(header: Text("Simulate Notifications")) {
                Button("🔥 Simulate Too Hot") {
                    NotificationManager.shared.sendNotification(
                        title: "🔥 Too Hot!",
                        body: "Temperature exceeded safe levels!"
                    )
                }
                Button("❄️ Simulate Too Cold") {
                    NotificationManager.shared.sendNotification(
                        title: "❄️ Too Cold!",
                        body: "Temperature dropped below normal!"
                    )
                }
                Button("🌫️ Simulate Polluted Air") {
                    NotificationManager.shared.sendNotification(
                        title: "🌫️ Air Too Polluted!",
                        body: "Air quality index is too high!"
                    )
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            // Ask for permission just in case
            NotificationManager.shared.requestPermission()
        }
    }
}
