import SwiftUI
import Charts

struct GraphView: View {
    @State private var readings: [SensorReading] = []
    
    var body: some View {
        VStack {
            if readings.isEmpty {
                ProgressView("Loading data…")
            } else {
                Chart {
                    ForEach(readings) { reading in
                        LineMark(
                            x: .value("Time", reading.time),
                            y: .value("Temperature", reading.temperature)
                        )
                        .foregroundStyle(.orange)
                        
                        LineMark(
                            x: .value("Time", reading.time),
                            y: .value("Humidity", reading.humidity)
                        )
                        .foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Time", reading.time),
                            y: .value("Air Quality", reading.airQuality)
                        )
                        .foregroundStyle(.green)
                    }
                }
                .frame(height: 300)
                .padding()
            }
        }
        .onAppear(perform: fetchData)
    }
    
    func fetchData() {
        guard let url = URL(string: "http://127.0.0.1:8000/sensor") else { return }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let temp = json["temperature"] as? Double,
                   let hum = json["humidity"] as? Double,
                   let air = json["air_quality"] as? Double {
                    
                    DispatchQueue.main.async {
                        readings.append(SensorReading(
                            time: Date(),
                            temperature: temp,
                            humidity: hum,
                            airQuality: air
                        ))
                        
                        if readings.count > 20 {
                            readings.removeFirst()
                        }
                    }
                }
            }.resume()
        }
    }
}

struct SensorReading: Identifiable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let humidity: Double
    let airQuality: Double
}
