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
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
        }
    }
}
