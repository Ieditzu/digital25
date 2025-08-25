import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2.fill")
                }
            GraphView()
                .tabItem {
                    Label("Graphs", systemImage: "waveform.path.ecg")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            ControlView()
                .tabItem {
                    Label("Control", systemImage: "heart")
                }
        }
        .animation(.easeInOut, value: UUID())
    }
}
