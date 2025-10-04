import Foundation
import UserNotifications

class SensorManager: ObservableObject {
    @Published var temperature: Double = 0.0
    @Published var airQuality: Int = 100

    func updateSensorData(_ data: SensorData) {
        self.temperature = data.temperature
        self.airQuality = data.airQuality

        // Threshold checks
        if temperature > 28 {
            sendNotification(title: "Room Too Hot", body: "The temperature is \(temperature)°C.")
        }

        if airQuality < 50 {
            sendNotification(title: "Poor Air Quality", body: "The air quality is \(airQuality).")
        }
    }

    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
