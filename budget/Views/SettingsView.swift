import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            Form {
                Section("Income") {
                    Text("Monthly income: $\(appState.settings.monthlyIncome, specifier: "%.2f")")
                }

                Section("Categories") {
                    ForEach(appState.settings.categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(
            AppState(
                settings: UserSettings(
                    monthlyIncome: 3200,
                    categories: ["Rent", "Food", "Transportation"]
                )
            )
        )
}
