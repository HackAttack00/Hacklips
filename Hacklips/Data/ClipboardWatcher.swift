//
//  ClipboardWatcher.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/06.
//

import Cocoa

class ClipboardWatcher: NSObject {
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var timer: Timer?
    
    override init() {
        super.init()
    }
    
    func startWatcher() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        guard NSPasteboard.general.changeCount != lastChangeCount else {
            return
        }
        lastChangeCount = NSPasteboard.general.changeCount
        if let text = NSPasteboard.general.string(forType: .string) {
            handleClipboardChange(text: text)
        }
    }
    
    func handleClipboardChange(text: String) {
        print("handleClipboardChange = \(text)")
        //세이브를 어떻게 호출하라는거야
//        Task(priority: .high) {
//            await ClipsData().saveClip(clipText: text)
//        }
    }
}
