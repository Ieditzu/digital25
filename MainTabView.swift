import SwiftUI

struct MainTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView()
            
            TabView {
                DashboardView()
                    .tabItem { Label("Dashboard", systemImage: "speedometer") }
                
                GraphView()
                    .tabItem { Label("Graph", systemImage: "chart.bar") }
                
                ControlView()
                    .tabItem { Label("Control", systemImage: "gamecontroller") }
                
                MrGreenAIView()
                    .tabItem { Label("Mr. Green", systemImage: "leaf.circle.fill")}
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
        }
    }
}
