import SwiftUI

struct MainTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Persistent header at the top
            HeaderView()
            
            // The TabView with all your tabs
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "speedometer")
                    }
                
                GraphView()
                    .tabItem {
                        Label("Graph", systemImage: "chart.bar")
                    }
                
                ControlView()
                    .tabItem {
                        Label("Control", systemImage: "gamecontroller")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
        }
        .edgesIgnoringSafeArea(.top) // optional: header goes to top edge
    }
}
