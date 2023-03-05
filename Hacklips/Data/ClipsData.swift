//
//  ClipsData.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import CoreData
import AppKit

class ClipsData: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init() {
        container = NSPersistentCloudKitContainer(name: "Hacklips")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    static func getLastCopiedString() -> String? {
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
