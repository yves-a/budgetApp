//
//  LogExpenseView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//


import SwiftUI

struct LogExpenseView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    // Form fields
    @State private var date = Date()
    @State private var amountText: String = ""
    @State private var category: String = ""
    @State private var description: String = ""

    // Simple validation
    private var isFormValid: Bool {
        guard
            !category.isEmpty,
            !amountText.isEmpty,
            Double(amountText) != nil
        else {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $category) {
                        ForEach(appState.settings.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }

                    // Description with placeholder
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Enter a description…")
                                .foregroundColor(.gray)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 6)
                        }

                        TextEditor(text: $description)
                            .frame(minHeight: 120)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                }

                Section {
                    Button(action: logExpense) {                        Text("Log Expense")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Log Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func logExpense() {
        guard
            let amountValue = Double(amountText)
        else {
            return
        }

        appState.logExpense(
            date: date,
            amount: amountValue,
            category: category,
            description: description
        )

        dismiss()
    }
}

#Preview {
    LogExpenseView()
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
