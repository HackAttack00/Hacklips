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
    
    func saveClip(clipText: String) async {
        await self.eraseClip(searchString: clipText)
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
    
    func eraseClip(clip: Clips) async {
        await self.container.viewContext.perform {
            self.container.viewContext.delete(clip)
            do {
                try self.container.viewContext.save()
            } catch {
                print("Error delete clip")
            }
        }
    }
    
    func eraseClip(searchString: String) async {
        await self.container.viewContext.perform {
            let fetchRequest: NSFetchRequest<Clips> = Clips.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "pastedText CONTAINS %@", searchString)

            let context = self.container.viewContext
            if let results = try? context.fetch(fetchRequest) {
                for result in results {
                    context.delete(result)
                }
                try? context.save()
            }
        }
    }
    
    func savePin(clipText: String) async {
        await self.eraseClip(searchString: clipText)
        let managedContext = self.container.viewContext
        await managedContext.perform {
            let newClip = Clips(context: managedContext)
            newClip.pastedText = clipText
            newClip.timestamp = Date()
            newClip.pinned = true
            do {
                try self.container.viewContext.save()
            } catch {
                print("Error savePin")
            }
        }
    }
    
    func erasePin(clipText: String) async {
        await self.eraseClip(searchString: clipText)
        let managedContext = self.container.viewContext
        await managedContext.perform {
            let newClip = Clips(context: managedContext)
            newClip.pastedText = clipText
            newClip.timestamp = Date()
            newClip.pinned = false
            do {
                try self.container.viewContext.save()
            } catch {
                print("Error erasePin")
            }
        }
    }
    
//    func fetchClip(withPastedText pastedText: String) -> Any? {
//        let managedContext = self.container.viewContext
//        let fetchRequest: NSFetchRequest<Clips> = Clips.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "pastedText CONTAINS %@", pastedText)
//
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            return results.first
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            return nil
//        }
//    }
}
