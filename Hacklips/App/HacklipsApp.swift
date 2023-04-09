//
//  HacklipsApp.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/04.
//

import SwiftUI

@main
struct HacklipsApp: App {
    var clipsData = ClipsData.shared
    @State var currentNumber: String = "1"

//    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            ClipsMainView()
                .environmentObject(clipsData)
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
        
        
        MenuBarExtra("Hacklips", systemImage: "chart.line.uptrend.xyaxis.circle") {
            ExtraViewClipListView()
                .environment(\.managedObjectContext, clipsData.container.viewContext)
        }
    }
}
//
//class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
//
//    var hotKey: EventHotKeyRef?
//    @MainActor
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        hotKey = createHotKey(key: kVK_ANSI_C, modifiers: [.command, .shift], handler: {
//            print("Global shortcut pressed!")
//        })
//    }
//
//    func createHotKey(key: Int, modifiers: NSEvent.ModifierFlags, handler: @escaping () -> Void) -> EventHotKeyRef? {
//        let eventHandler: EventHandlerUPP = {(_, _, eventRef) -> OSStatus in
//            handler()
//            return noErr
//        }
//
//        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
//        let status = RegisterEventHotKey(UInt32(key), UInt32(modifiers.rawValue), EventHotKeyID(signature: 0, id: 1), GetApplicationEventTarget(), 0, &hotKey)
//        if status != noErr {
//            return nil
//        }
//
//        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(hotKey).toOpaque())
//        InstallEventHandler(GetEventDispatcherTarget(), eventHandler, 1, &eventType, context, nil)
//
//        return hotKey
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        if let hotKey = hotKey {
//            UnregisterEventHotKey(hotKey, 0)
//            let object = Unmanaged.passRetained(hotKey as AnyObject).toOpaque()
//            object.release()
//        }
//    }
//}

