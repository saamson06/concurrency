//
//  concurrencyApp.swift
//  concurrency
//
//  Created by Samson Lawrence on 2026-01-21.
//

import SwiftUI
import CoreData

@main
struct concurrencyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
