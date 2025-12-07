//
//  Models.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import Foundation

struct Debt: Identifiable, Hashable {
    let id: UUID
    var name: String           // "Visa Card", "Student Loan"
    var type: String           // "Credit Card", "Loan"
    var balance: Double        // current amount owed
    var interestRate: Double   // APR, e.g. 19.99
    var minimumPayment: Double // required monthly minimum
    var dueDay: Int            // day of month, e.g. 15
}

struct Transaction: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var amount: Double
    var category: String       // "Food", "Rent", etc.
    var description: String?   // optional note
}

struct UserSettings {
    var monthlyIncome: Double
    var categories: [String]
}

