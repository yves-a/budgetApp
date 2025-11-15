import SwiftUI

struct PlanView: View {
    @EnvironmentObject var appState: AppState

    var totalMinimumPayments: Double {
        appState.debts.reduce(0) { $0 + $1.minimumPayment }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Payment Plan")
                    .font(.largeTitle)
                    .bold()

                Text("Monthly Income: $\(appState.settings.monthlyIncome, specifier: "%.2f")")
                Text("Total Minimum Payments: $\(totalMinimumPayments, specifier: "%.2f")")

                let leftover = appState.settings.monthlyIncome - totalMinimumPayments
                Text("Estimated leftover after minimums: $\(leftover, specifier: "%.2f")")
                    .foregroundStyle(leftover >= 0 ? .green : .red)

                Spacer()
            }
            .padding()
            .navigationTitle("Plan")
        }
    }
}

#Preview {
    PlanView()
        .environmentObject(
            AppState(
                debts: [
                    Debt(id: UUID(), name: "Visa Card", type: "Credit Card", balance: 2500, interestRate: 19.99, minimumPayment: 75, dueDay: 15),
                    Debt(id: UUID(), name: "Student Loan", type: "Loan", balance: 12000, interestRate: 4.5, minimumPayment: 150, dueDay: 1)
                ],
                settings: UserSettings(monthlyIncome: 3000, categories: ["Rent", "Food"])
            )
        )
}
