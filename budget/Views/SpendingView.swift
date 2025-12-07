//
//  SpendingView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//


import SwiftUI

struct SpendingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.editMode) private var editMode
    @State private var showingLogExpenseSheet = false
    
    @State private var editingExpense: Transaction? = nil
    @State private var showingEditSheet = false



    var totalSpentThisMonth: Double {
        // For Phase 0, just sum everything
        appState.transactions.reduce(0) { $0 + $1.amount }
    }
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.title)
                .bold()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Expenses")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("$\(totalSpentThisMonth, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                }
            }
        }
        .padding()
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              alignment: .leading
            )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                showingLogExpenseSheet = true
            } label: {
                Text("Log Expense")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            Button {
                withAnimation {
                    editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                }
            } label: {
                Text(editMode?.wrappedValue == .active ? "Done" : "Edit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)


            
        }
    }
    
    struct ExpenseRow: View {
        let transaction: Transaction
        let date: Date
        let amount: Double
        let category: String
        let description: String?
        
        @State private var formattedDate: String = ""
        
        var body: some View {
            HStack (spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(category)
                        .font(.headline)
                    if let description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                   
                            
                    
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedDate)
                        .font(.caption)
                    Text("$\(amount, specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .onAppear {
                formattedDate = date.formatted(.iso8601.year().month().day())
            }

            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .stroke(Color(.systemGray6), lineWidth: 4)
            )
        }
    }
    private func delete(expense: Transaction) {
        if let index = appState.transactions.firstIndex(where: { $0.id == expense.id }) {
            appState.transactions.remove(at: index)
        }
    }

    
    private func deleteOffsets(at offsets: IndexSet) {
        appState.transactions.remove(atOffsets: offsets)
    }

    var expensesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            List {
                ForEach(appState.transactions) { expense in
                    ExpenseRow(
                        transaction: expense,
                        date: expense.date,
                        amount: expense.amount,
                        category: expense.category,
                        description: expense.description
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingExpense = expense
                        showingEditSheet = true
                    }
                }
                .onDelete(perform: deleteOffsets)
            }
            .listStyle(.plain)
            .environment(\.editMode, editMode)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                summaryCard
                
                actionButtons
                
                expensesCard
            }
            .padding()
            .navigationTitle("Spending")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingLogExpenseSheet) {
                LogExpenseView()
                    .environmentObject(appState)
            }
            .sheet(item: $editingExpense) { expense in
                LogExpenseView(expenseToEdit: expense)
                    .environmentObject(appState)
            }

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
