import SwiftUI

struct ControlView: View {
    // Panel positions
    @State private var joystickPosition: CGSize = CGSize(width: 50, height: 400)
    @State private var radarPosition: CGSize = CGSize(width: 200, height: 100)
    
    // Joystick state
    @State private var joystickOffset: CGSize = .zero
    @State private var speed: Double = 0.0
    @State private var direction: String = "stop"
    
    // Radar state
    @State private var distance: Double = 100
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.05).edgesIgnoringSafeArea(.all)
            
            // Joystick panel
            DraggablePanel(position: $joystickPosition, title: "Joystick") {
                JoystickView(offset: $joystickOffset, speed: $speed, direction: $direction)
                    .frame(width: 150, height: 150)
            }
            
            // Radar panel
            DraggablePanel(position: $radarPosition, title: "Front Radar") {
                RadarView(distance: $distance)
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                fetchSensorDistance()
                sendControlCommand()
            }
        }
    }
    
    func fetchSensorDistance() {
        guard let url = URL(string: "http://127.0.0.1:8000/sensor") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let front = json["front_distance"] as? Double else { return }
            DispatchQueue.main.async {
                distance = front
            }
        }.resume()
    }
    
    func sendControlCommand() {
        guard let url = URL(string: "http://127.0.0.1:8000/control") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let json: [String: Any] = ["command": direction, "speed": speed]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request).resume()
    }
}

// Generic draggable panel
struct DraggablePanel<Content: View>: View {
    @Binding var position: CGSize
    let title: String
    let content: Content
    
    init(position: Binding<CGSize>, title: String, @ViewBuilder content: () -> Content) {
        self._position = position
        self.title = title
        self.content = content()
    }
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
            
            content
                .padding(8)
        }
        .background(Color.gray.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
        .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    dragOffset = gesture.translation
                }
                .onEnded { _ in
                    position.width += dragOffset.width
                    position.height += dragOffset.height
                    dragOffset = .zero
                }
        )
    }
}

// Radar
struct RadarView: View {
    @Binding var distance: Double
    let maxDistance: Double = 100
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle().stroke(Color.green.opacity(0.5), lineWidth: 2)
                Circle().stroke(Color.green.opacity(0.3), lineWidth: 2).scaleEffect(0.75)
                Circle().stroke(Color.green.opacity(0.2), lineWidth: 2).scaleEffect(0.5)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 4, height: CGFloat(min(distance,maxDistance))/CGFloat(maxDistance) * geo.size.width/2)
                    .offset(y: -CGFloat(min(distance,maxDistance))/CGFloat(maxDistance) * geo.size.width/4)
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

// Joystick
struct JoystickView: View {
    @Binding var offset: CGSize
    @Binding var speed: Double
    @Binding var direction: String
    
    var body: some View {
        ZStack {
            Circle().stroke(Color.gray, lineWidth: 2)
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 50, height: 50)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let maxDistance: CGFloat = 50
                            let dx = min(max(gesture.translation.width, -maxDistance), maxDistance)
                            let dy = min(max(gesture.translation.height, -maxDistance), maxDistance)
                            offset = CGSize(width: dx, height: dy)
                            
                            speed = min(1.0, sqrt(dx*dx + dy*dy)/maxDistance)
                            if dy < -10 { direction = "forward" }
                            else if dy > 10 { direction = "backward" }
                            else if dx < -10 { direction = "left" }
                            else if dx > 10 { direction = "right" }
                            else { direction = "stop" }
                        }
                        .onEnded { _ in
                            offset = .zero
                            speed = 0
                            direction = "stop"
                        }
                )
        }
    }
}
