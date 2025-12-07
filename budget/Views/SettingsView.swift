//
//  SettingsView.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.editMode) private var editMode
    
    @State private var editingCategory = false
    @State private var editingIncome = false
    @State private var incomeText = ""
    @State private var showingAddCategorySheet = false
    @State private var newCategoryName = ""

    
    
    private func deleteOffsets(at offsets: IndexSet) {
        appState.settings.categories.remove(atOffsets: offsets)
    }
    
    struct categoryRow: View {
        @Binding var name : String
        @Binding var editingCategory: Bool
        
        @State private var text: String = ""
        var body: some View {
            HStack (spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    
                    if editingCategory {
                        TextField("", text: $text)
                            .frame(width: 70)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: text) { 
                            }
                    } else {
                        Text(name)
                            .font(.headline)
                    }
                    
                   
                            
                    
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    if editingCategory {
                        Button("Done") {
                            editingCategory = false
                            name = text
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        
    }
    
    var categories: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("Categories")
                    .font(.title2)
                Spacer()
                Button {
                    showingAddCategorySheet = true
                } label: {
                    Label("Add", systemImage: "plus")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)

            }
            
            
            List {
                ForEach(Array(appState.settings.categories.enumerated()), id: \.offset) { index, category in
                    categoryRow(
                            name: $appState.settings.categories[index],
                            editingCategory: $editingCategory
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingCategory = true
                        }
                    }
                .onDelete(perform: deleteOffsets)
            }
            .listStyle(.plain)
            .environment(\.editMode, editMode)
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            VStack(spacing: 20) {
                Text("Add New Category")
                    .font(.title2)
                    .bold()

                TextField("Category name", text: $newCategoryName)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                HStack {
                    Button("Cancel") {
                        showingAddCategorySheet = false
                        newCategoryName = ""
                    }
                    .buttonStyle(.bordered)

                    Button("Add") {
                        if !newCategoryName.isEmpty {
                            appState.settings.categories.append(newCategoryName)
                        }
                        showingAddCategorySheet = false
                        newCategoryName = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newCategoryName.isEmpty)
                }

                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.28)])
                .presentationDragIndicator(.visible)
        }

    }

    var incomeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Income")
                .font(.title2)

            HStack {
                if editingIncome {
                    TextField("", text: $incomeText)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)

                    Spacer()

                    Button("Done") {
                        if let value = Double(incomeText) {
                            appState.settings.monthlyIncome = value
                        }
                        editingIncome = false
                    }
                    .buttonStyle(.borderedProminent)

                } else {
                    Text("$\(appState.settings.monthlyIncome, specifier: "%.2f")")
                        .font(.headline)

                    Spacer()

                    Button("Edit") {
                        incomeText = String(format: "%.2f", appState.settings.monthlyIncome)
                        editingIncome = true
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }

    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                incomeCard
                categories
                
                
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(
            AppState(
                settings: UserSettings(
                    monthlyIncome: 3200,
                    categories: ["Rent", "Food", "Transportation"]
                )
            )
        )
}
