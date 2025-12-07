//
//  AppState.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    // Core data the whole app cares about
    @Published var debts: [Debt]
    @Published var transactions: [Transaction]
    @Published var settings: UserSettings

    init(
        debts: [Debt] = [],
        transactions: [Transaction] = [],
        settings: UserSettings = UserSettings(
            monthlyIncome: 0,
            categories: ["Rent", "Food", "Transportation", "Entertainment", "Other"]
        )
    ) {
        self.debts = debts
        self.transactions = transactions
        self.settings = settings
    }
    
    func addDebt(
        name: String,
        type: String,
        balance: Double,
        interestRate: Double,
        minimumPayment: Double,
        dueDay: Int
    ) {
        let newDebt = Debt(
                    id: UUID(),
                    name: name,
                    type: type,
                    balance: balance,
                    interestRate: interestRate,
                    minimumPayment: minimumPayment,
                    dueDay: dueDay
        )
        debts.append(newDebt)
    }
    func logExpense(
        date: Date,
        amount: Double,
        category: String,
        description: String? = ""
    ) {
        let newTransaction = Transaction(
            id: UUID(),
            date: date,
            amount: amount,
            category: category,
            description: description
        )
        transactions.append(newTransaction)
    }
}

