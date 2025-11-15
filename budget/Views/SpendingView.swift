import SwiftUI

struct SpendingView: View {
    @EnvironmentObject var appState: AppState

    var totalSpentThisMonth: Double {
        // For Phase 0, just sum everything
        appState.transactions.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Spending")
                    .font(.largeTitle)
                    .bold()

                Text("Total logged spending: $\(totalSpentThisMonth, specifier: "%.2f")")

                List(appState.transactions) { txn in
                    VStack(alignment: .leading) {
                        Text(txn.category)
                            .font(.headline)
                        Text("$\(txn.amount, specifier: "%.2f") • \(txn.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                        if let desc = txn.description {
                            Text(desc)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Spending")
        }
    }
}

#Preview {
    SpendingView()
        .environmentObject(
            AppState(
                transactions: [
                    Transaction(id: UUID(), date: .now, amount: 45.20, category: "Food", description: "Groceries"),
                    Transaction(id: UUID(), date: .now, amount: 1200, category: "Rent", description: nil)
                ]
            )
        )
}
