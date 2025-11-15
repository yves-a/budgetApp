import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            PlanView()
                .tabItem {
                    Label("Plan", systemImage: "target")
                }

            SpendingView()
                .tabItem {
                    Label("Spending", systemImage: "creditcard.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppState())
}
