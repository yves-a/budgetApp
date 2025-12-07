//
//  AddDebtView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import SwiftUI

struct AddDebtView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    // Form fields
    @State private var name: String = ""
    @State private var type: String = "Credit Card"
    @State private var balanceText: String = ""
    @State private var interestRateText: String = ""
    @State private var minimumPaymentText: String = ""
    @State private var dueDayText: String = ""   // day of month, e.g. "15"

    // Simple validation
    private var isFormValid: Bool {
        guard
            !name.isEmpty,
            !balanceText.isEmpty,
            !interestRateText.isEmpty,
            !minimumPaymentText.isEmpty,
            !dueDayText.isEmpty,
            Double(balanceText) != nil,
            Double(interestRateText) != nil,
            Double(minimumPaymentText) != nil,
            Int(dueDayText) != nil
        else {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Debt Details") {
                    TextField("Name (e.g. Visa Card)", text: $name)

                    TextField("Type (Credit Card, Loan, etc.)", text: $type)

                    TextField("Balance", text: $balanceText)
                        .keyboardType(.decimalPad)

                    TextField("Interest Rate (APR %)", text: $interestRateText)
                        .keyboardType(.decimalPad)

                    TextField("Minimum Payment", text: $minimumPaymentText)
                        .keyboardType(.decimalPad)

                    TextField("Due Day of Month (1–31)", text: $dueDayText)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button(action: saveDebt) {
                        Text("Save Debt")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Add Debt")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveDebt() {
        guard
            let balance = Double(balanceText),
            let apr = Double(interestRateText),
            let minPayment = Double(minimumPaymentText),
            let dueDay = Int(dueDayText)
        else {
            return
        }

        appState.addDebt(
            name: name,
            type: type,
            balance: balance,
            interestRate: apr,
            minimumPayment: minPayment,
            dueDay: dueDay
        )

        dismiss()
    }
}

#Preview {
    AddDebtView()
        .environmentObject(
            AppState(
                debts: [],
                transactions: [],
                settings: UserSettings(
                    monthlyIncome: 3000,
                    categories: ["Rent", "Food"]
                )
            )
        )
}
