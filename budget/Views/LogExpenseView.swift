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
    
    let expenseToEdit: Transaction?

    // Form fields
    @State private var date = Date()
    @State private var amountText: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    
    init(expenseToEdit: Transaction? = nil) {
            self.expenseToEdit = expenseToEdit

            if let e = expenseToEdit {
                // EDIT MODE: prefill from existing transaction
                _date = State(initialValue: e.date)
                _amountText = State(initialValue: String(e.amount))
                _category = State(initialValue: e.category)
                _description = State(initialValue: e.description ?? "")
            } else {
                // ADD MODE: empty form
                _date = State(initialValue: Date())
                _amountText = State(initialValue: "")
                _category = State(initialValue: "")
                _description = State(initialValue: "")
            }
        }

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
                    Button(action: saveExpense) {
                        Text(expenseToEdit == nil ? "Log Expense" : "Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle(expenseToEdit == nil ? "Log Expense" : "Edit Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let e = expenseToEdit {
                    date = e.date
                    amountText = String(e.amount)
                    category = e.category
                    description = e.description ?? ""
                }
            }

        }
    }

    private func saveExpense() {
        guard let amountValue = Double(amountText) else { return }

        if let existing = expenseToEdit {
            // EDIT MODE
            if let index = appState.transactions.firstIndex(where: { $0.id == existing.id }) {
                appState.transactions[index].date = date
                appState.transactions[index].amount = amountValue
                appState.transactions[index].category = category
                appState.transactions[index].description = description
            }
        } else {
            // ADD MODE
            appState.logExpense(
                date: date,
                amount: amountValue,
                category: category,
                description: description
            )
        }

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
