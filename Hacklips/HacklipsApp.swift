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

        Button(action: editClipBoard, label: { Text("Edit Clips") })
    }
    
    func action1() {
        if let lastPastedString = getLastCopiedString() {
            print("lastPastedString = \(lastPastedString)")
        }
    }
    
    func action2() {
        
    }
    
    func editClipBoard() {
        //클립보드 수정 페이지를 보여준다
    }

    func getLastCopiedString() -> String? {
        let pboard = NSPasteboard.general
        
        var lastCopiedString:String? = nil
        if let items = pboard.pasteboardItems {
            items.forEach { item in
                if let pasteString = item.string(forType: NSPasteboard.PasteboardType.string) {
                    lastCopiedString = pasteString
                }
            }
            return lastCopiedString
        }
        return nil
    }
}
    
