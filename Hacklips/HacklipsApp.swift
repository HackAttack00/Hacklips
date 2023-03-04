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
    
    @State var currentNumber: String = "1"
    
    var body: some Scene {
        
        MenuBarExtra("Hacklips", systemImage: "hammer") {
            clipMenuBarExtraView()
        }
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct clipMenuBarExtraView: View {
    var body: some View {
        Button(action: action1, label: { Text("Action 1") })
        Button(action: action2, label: { Text("Action 2") })
        
        Divider()

        Button(action: action3, label: { Text("Action 3") })
    }
    
    func action1() {}
    func action2() {}
    func action3() {}

}
    
