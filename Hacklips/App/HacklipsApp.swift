//
//  HacklipsApp.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/04.
//

import SwiftUI

@main
struct HacklipsApp: App {
    @StateObject var clipsData = ClipsData()
    @State var currentNumber: String = "1"
    
    var body: some Scene {
        
        MenuBarExtra("Hacklips", systemImage: "hammer") {
            ClipMenuBarExtraView()
        }
        
        WindowGroup {
            ClipsMainView()
                .environmentObject(clipsData)
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
    }
}


    
