//
//  RootTabView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//


import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            PlanView()
                .tabItem {
                    Label("Plan", systemImage: "target")
                }

            SpendingView()
                .tabItem {
                    Label("Spending", systemImage: "creditcard.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    RootTabView()
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
