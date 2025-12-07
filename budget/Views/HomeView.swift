//
//  Home.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddDebtSheet = false
    @State private var showingLogExpenseSheet = false
    private let calendar = Calendar.current

    // MARK: - Computed values

    private var totalDebt: Double {
        appState.debts.reduce(0) { $0 + $1.balance }
    }

    private var totalMinimumPayments: Double {
        appState.debts.reduce(0) { $0 + $1.minimumPayment }
    }

    private var currentMonthTransactions: [Transaction] {
        let now = Date()
        return appState.transactions.filter { txn in
            let txnComponents = calendar.dateComponents([.year, .month], from: txn.date)
            let nowComponents = calendar.dateComponents([.year, .month], from: now)
            return txnComponents.year == nowComponents.year &&
                   txnComponents.month == nowComponents.month
        }
    }

    private var totalSpentThisMonth: Double {
        currentMonthTransactions.reduce(0) { $0 + $1.amount }
    }

    private var topSpendingCategory: (name: String, amount: Double)? {
        let grouped = Dictionary(grouping: currentMonthTransactions, by: { $0.category })
        let sums = grouped.mapValues { txns in
            txns.reduce(0) { $0 + $1.amount }
        }
        guard let (name, amount) = sums.max(by: { $0.value < $1.value }) else {
            return nil
        }
        return (name, amount)
    }

    // Upcoming = next 3 debts by due day
    private var upcomingDebts: [Debt] {
        appState.debts
            .sorted(by: { $0.dueDay < $1.dueDay })
            .prefix(3)
            .map { $0 }
    }
    
    func openAddDebtModal() {
        
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    summaryCard
                    
                    actionButtons
                    
                    Divider()

                    if !upcomingDebts.isEmpty {
                        upcomingPaymentsSection
                        Divider()
                    }
                    
                   

                    spendingSummarySection
                    
                    Divider()

                    debtsSection
                

                    Spacer(minLength: 24)

                    
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddDebtSheet) {
            AddDebtView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showingLogExpenseSheet) {
            LogExpenseView()
                .environmentObject(appState)
        }
    }

    // MARK: - Sections

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title)
                .bold()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Debt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(totalDebt, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Income")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(appState.settings.monthlyIncome, specifier: "%.2f")")
                        .font(.title3)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Min Payments")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(totalMinimumPayments, specifier: "%.2f")")
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }

    private var upcomingPaymentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Upcoming Payments")
                .font(.title)

            ForEach(upcomingDebts) { debt in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(debt.name)
                            .font(.subheadline)
                            .bold()
                        Text("Due day: \(debt.dueDay)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("$\(debt.minimumPayment, specifier: "%.2f")")
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var spendingSummarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spending This Month")
                .font(.title)

            Text("Total: $\(totalSpentThisMonth, specifier: "%.2f")")
                .font(.subheadline)

            if let top = topSpendingCategory {
                Text("Top category: \(top.name) ($\(top.amount, specifier: "%.2f"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("No spending logged yet.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var debtsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Debts")
                .font(.title)

            if appState.debts.isEmpty {
                Text("No debts added yet. Tap \"Add Debt\" below to get started.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(appState.debts) { debt in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(debt.name)
                            .font(.subheadline)
                            .bold()
                        Text("Balance: $\(debt.balance, specifier: "%.2f")")
                            .font(.caption)
                        Text("Min: $\(debt.minimumPayment, specifier: "%.2f") • APR: \(debt.interestRate, specifier: "%.2f")%")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)

                    Divider()
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                showingAddDebtSheet = true
            } label: {
                Text("+ Add Debt")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                showingLogExpenseSheet = true
            } label: {
                Text("+ Log Expense")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Preview

#Preview {
    let sampleState = AppState(
        debts: [
            Debt(
                id: UUID(),
                name: "Visa Card",
                type: "Credit Card",
                balance: 2500,
                interestRate: 19.99,
                minimumPayment: 75,
                dueDay: 15
            ),
            Debt(
                id: UUID(),
                name: "Student Loan",
                type: "Loan",
                balance: 12000,
                interestRate: 4.5,
                minimumPayment: 150,
                dueDay: 1
            ),
            Debt(
                id: UUID(),
                name: "MasterCard",
                type: "Credit Card",
                balance: 800,
                interestRate: 22.99,
                minimumPayment: 45,
                dueDay: 27
            )
        ],
        transactions: [
            Transaction(
                id: UUID(),
                date: Date(),
                amount: 45.20,
                category: "Food",
                description: "Groceries"
            ),
            Transaction(
                id: UUID(),
                date: Date(),
                amount: 1200,
                category: "Rent",
                description: nil
            ),
            Transaction(
                id: UUID(),
                date: Date(),
                amount: 18.50,
                category: "Entertainment",
                description: "Movie night"
            )
        ],
        settings: UserSettings(
            monthlyIncome: 3200,
            categories: ["Rent", "Food", "Transportation", "Entertainment", "Other"]
        )
    )

    return HomeView()
        .environmentObject(sampleState)
}
