//
//  HacklipsApp.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/04.
//

import SwiftUI

@main
struct HacklipsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
