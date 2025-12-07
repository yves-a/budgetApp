//
//  PlanView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var appState: AppState
    
    // Total amount user wants to put toward debts this month
    @State private var moneyToDebts: Double = 0
    @State private var moneyToDebtsText: String = ""  // text field backing
    
    // Per-debt planned payments
    @State private var payments: [UUID: Double] = [:]

    // MARK: - Computed values
    
    var totalMinimumPayments: Double {
        appState.debts.reduce(0) { $0 + $1.minimumPayment }
    }
    
    private var totalDebt: Double {
        appState.debts.reduce(0) { $0 + $1.balance }
    }
    
    private var totalPlannedPayments: Double {
        payments.values.reduce(0, +)
    }
    
    private var remainingAllocationRaw: Double {
        moneyToDebts - totalPlannedPayments
    }

    // MARK: - Summary Card
    
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
    
    // MARK: - Allocation Slider Card
    
    private var adjustMoneyToDebtsCard: some View {
        // Binding that keeps slider & text in sync and always finite
        let allocationBinding = Binding<Double>(
            get: { moneyToDebts },
            set: { newValue in
                let maxIncome = appState.settings.monthlyIncome
                let clamped = min(max(newValue, 0), maxIncome)
                moneyToDebts = clamped
                moneyToDebtsText = String(Int(clamped.rounded()))
            }
        )
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Money to Debts")
                .font(.headline)

            HStack(spacing: 12) {
                Slider(
                    value: allocationBinding,
                    in: 0...appState.settings.monthlyIncome,
                    step: 5
                ) {
                    Text("Money to Debts")
                } minimumValueLabel: {
                    Text("0")
                        .font(.caption)
                } maximumValueLabel: {
                    Text("$\(appState.settings.monthlyIncome, specifier: "%.0f")")
                        .font(.caption)
                }

                // String-backed TextField to avoid NaN
                TextField("", text: $moneyToDebtsText)
                    .frame(width: 80)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: moneyToDebtsText) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            moneyToDebtsText = filtered
                        }
                        let number = Double(filtered) ?? 0
                        let maxIncome = appState.settings.monthlyIncome
                        moneyToDebts = min(max(number, 0), maxIncome)
                    }
            }

            Text("Allocated: $\(moneyToDebts, specifier: "%.2f")")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .stroke(Color(.systemGray6), lineWidth: 4)
        )
    }
    
    // MARK: - Debt Payment Row
    
    struct DebtPaymentRow: View {
        let debt: Debt
        @Binding var payment: Double
        
        @State private var text: String = ""
        
        var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(debt.name)
                        .font(.headline)
                    Text(debt.type)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Due in \(debt.dueDay) days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Balance: $\(debt.balance, specifier: "%.2f")")
                        .font(.caption)
                    
                    HStack {
                        Text("Pay:")
                            .font(.caption)
                        
                        TextField("", text: $text)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: text) { _, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    text = filtered
                                }
                                let number = Double(filtered) ?? 0
                                payment = number
                            }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .stroke(Color(.systemGray6), lineWidth: 4)
            )
            .onAppear {
                if text.isEmpty {
                    text = String(Int(payment.rounded()))
                }
            }
        }
    }
    
    // MARK: - Split For Debts Card
    
    private var splitForDebtsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Split your money for debts")
                .font(.headline)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(appState.debts.sorted(by: { $0.dueDay < $1.dueDay })) { debt in
                        let paymentBinding = Binding<Double>(
                            get: { payments[debt.id] ?? debt.minimumPayment },
                            set: { newValue in
                                payments[debt.id] = max(newValue, 0)
                            }
                        )
                        
                        DebtPaymentRow(debt: debt, payment: paymentBinding)
                    }
                }
            }

            
            // Simple status — no NaN math
            let remaining = remainingAllocationRaw
            Text(
                remaining >= 0
                ? "Remaining allocation: $\(remaining, specifier: "%.2f")"
                : "Over allocated by: $\(abs(remaining), specifier: "%.2f")"
            )
            .foregroundColor(remaining >= 0 ? .green : .red)
        }
    }

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                summaryCard
                adjustMoneyToDebtsCard
                splitForDebtsCard
            }
            .padding()
            .navigationTitle("Plan")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let maxIncome = appState.settings.monthlyIncome
                let initial = min(totalMinimumPayments, maxIncome)
                moneyToDebts = initial
                moneyToDebtsText = String(Int(initial.rounded()))
                
                for debt in appState.debts {
                    payments[debt.id] = debt.minimumPayment
                }
            }
        }
    }
}

#Preview {
    PlanView()
        .environmentObject(
            AppState(
                debts: [
                    Debt(id: UUID(), name: "Visa Card", type: "Credit Card", balance: 2500, interestRate: 19.99, minimumPayment: 75, dueDay: 15),
                    Debt(id: UUID(), name: "Student Loan", type: "Loan", balance: 12000, interestRate: 4.5, minimumPayment: 150, dueDay: 1),
                    Debt(id: UUID(), name: "AMEX Card", type: "Credit Card", balance: 2500, interestRate: 19.99, minimumPayment: 75, dueDay: 10),
                ],
                settings: UserSettings(monthlyIncome: 3000, categories: ["Rent", "Food"])
            )
        )
}
