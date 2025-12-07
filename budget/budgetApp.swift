//
//  budgetApp.swift
//  budget
//
//  Created by Yves Alikalfic on 2025-11-15.
//

import SwiftUI

@main
struct budgetApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appState)
        }
    }
}
