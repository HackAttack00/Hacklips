//
//  ClipsData.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import CoreData
import AppKit
import SwiftUI

class ClipsData: ObservableObject {
    static let shared = ClipsData()
    
    let container: NSPersistentCloudKitContainer
    
    private init() {
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
    
    func saveClip(clipText: String) async {
        await self.container.viewContext.perform {
            let newClip = Clips(context: self.container.viewContext)
            newClip.pastedText = clipText
            newClip.timestamp = Date()
            do {
                try self.container.viewContext.save()
            } catch {
                print("Error saving clip")
            }
        }
    }
    
    func eraseClip(clip: Clips) async{
        await self.container.viewContext.perform {
            self.container.viewContext.delete(clip)
            do {
                try self.container.viewContext.save()
            } catch {
                print("Error delete clip")
            }
        }
    }
}
