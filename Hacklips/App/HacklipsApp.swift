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
    @State var currentNumber: String = "1"

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ClipsMainView()
                .environmentObject(clipsData)
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    var clipsData = ClipsData.shared
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    @MainActor
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "paperclip.circle.fill", accessibilityDescription: "swift")
            statusButton.action = #selector(togglePopover)
        }
        
        
        let extraViewClipListView = ExtraViewClipListView()
                            .environment(\.managedObjectContext, clipsData.container.viewContext)
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width:300, height: 300)
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: extraViewClipListView)
    }
    
    @objc func togglePopover() {
        
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}

