import SwiftUI
import UserNotifications

struct DashboardView: View {
    @State private var temperature = "--"
    @State private var humidity = "--"
    @State private var airQuality = "--"
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    StatCard(title: "Temperature",
                             value: temperature + settings.temperatureUnit.rawValue,
                             color: .orange)
                    StatCard(title: "Humidity",
                             value: humidity + "%",
                             color: .blue)
                }
                StatCard(title: "Air Quality",
                         value: airQuality,
                         color: .green)
            }
            .padding()
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "http://192.168.0.109:8000/sensor") else { return }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let temp = json["temperature"] as? Double {
                            let convertedTemp = convertTemperature(temp)
                            temperature = String(format: "%.1f", convertedTemp)
                            checkTemperature(convertedTemp)
                        }
                        if let hum = json["humidity"] as? Double {
                            humidity = String(format: "%.1f", hum)
                        }
                        if let air = json["air_quality"] as? Double {
                            airQuality = String(format: "%.0f", air)
                            checkAirQuality(air)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func convertTemperature(_ celsius: Double) -> Double {
        settings.temperatureUnit == .fahrenheit ? (celsius * 9/5) + 32 : celsius
    }
    
    // MARK: - Threshold checks
    func checkTemperature(_ temp: Double) {
        let thresholdHigh: Double = settings.temperatureUnit == .fahrenheit ? 86 : 30
        let thresholdLow: Double = settings.temperatureUnit == .fahrenheit ? 41 : 5
        
        if temp > thresholdHigh {
            NotificationManager.shared.sendNotification(title: "🔥 Too Hot!",
                                                        body: "Temperature is \(String(format: "%.1f", temp))\(settings.temperatureUnit.rawValue)")
        } else if temp < thresholdLow {
            NotificationManager.shared.sendNotification(title: "❄️ Too Cold!",
                                                        body: "Temperature is \(String(format: "%.1f", temp))\(settings.temperatureUnit.rawValue)")
        }
    }
    
    func checkAirQuality(_ air: Double) {
        if air > 100 {
            NotificationManager.shared.sendNotification(title: "🌫️ Air Too Polluted!",
                                                        body: "Air quality is \(Int(air)). Avoid outdoor activities.")
        }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
