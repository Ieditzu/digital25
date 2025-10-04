import SwiftUI

struct ControlView: View {
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    @State private var isManual = false
    @State private var sendTimer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Robot Control")
                .font(.largeTitle)
                .bold()
                .padding(.top, 50)
            
            HStack(spacing: 20) {
                Button(action: {
                    isManual = false
                    sendMode("auto")
                    stopTimer()
                }) {
                    Text("Auto")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isManual ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    isManual = true
                    sendMode("manual")
                }) {
                    Text("Manual")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isManual ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            if isManual {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 4)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let radius: CGFloat = 100
                                    var translation = value.translation
                                    let distance = sqrt(translation.width * translation.width + translation.height * translation.height)
                                    if distance > radius {
                                        translation.width = translation.width / distance * radius
                                        translation.height = translation.height / distance * radius
                                    }
                                    dragOffset = translation
                                    isDragging = true
                                    
                                    startTimer()
                                }
                                .onEnded { _ in
                                    dragOffset = .zero
                                    isDragging = false
                                    stopTimer()
                                    sendJoystickCommand(translation: .zero, maxRadius: 100) // stop immediately
                                }
                        )
                }
                .frame(width: 200, height: 200)
                .padding(.top, 30)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // **TIMER**
    func startTimer() {
        if sendTimer == nil {
            sendTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                sendJoystickCommand(translation: dragOffset, maxRadius: 100)
            }
        }
    }
    
    func stopTimer() {
        sendTimer?.invalidate()
        sendTimer = nil
    }
    
    // MARK: - Networking
    func sendMode(_ mode: String) {
        sendToServer(["mode": mode])
    }
    
    func sendJoystickCommand(translation: CGSize, maxRadius: CGFloat) {
        let dx = translation.width / maxRadius
        let dy = -translation.height / maxRadius
        var direction = ""
        var speed: Double = sqrt(dx*dx + dy*dy)
        if speed > 1 { speed = 1 }
        
        if abs(dx) > abs(dy) {
            direction = dx > 0 ? "right" : "left"
        } else if abs(dy) > 0.05 {
            direction = dy > 0 ? "forward" : "backward"
        } else {
            direction = "stop"
        }
        
        let body: [String: Any] = [
            "mode": "manual",
            "command": direction,
            "speed": speed
        ]
        sendToServer(body)
    }
    
    func sendToServer(_ body: [String: Any]) {
        guard let url = URL(string: "http://192.168.0.109:8000/control") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request).resume()
    }
}
