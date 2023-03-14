//
//  HacklipsApp.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/04.
//

import SwiftUI

@main
struct HacklipsApp: App {
    @StateObject var clipsData = ClipsData.shared
    
    var body: some Scene {
        
        MenuBarExtra("Hacklips", systemImage: "hammer") {
            ExtraViewClipListView()
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
        
        WindowGroup {
            ClipsMainView()
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
    }
}


    
