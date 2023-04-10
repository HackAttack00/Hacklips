//
//  ExtraViewClipList.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/15.
//

import SwiftUI
import HotKey

struct ExtraViewClipListView: View {
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Clips.timestamp, ascending: false)], predicate: nil, animation: .default)
    private var listOfClips: FetchedResults<Clips>
    let hotkeys: [HotKey] = [HotKey(key: .one, modifiers: [.control, .command]),
                            HotKey(key: .two, modifiers: [.control, .command]),
                             HotKey(key: .three, modifiers: [.control, .command])]
    
    var body: some View {
        ForEach(listOfClips.indices, id: \.self) { index in
            let pastedText = listOfClips[index].pastedText ?? ""
            Button(pastedText) {
                copyToClipBoard(clipText: pastedText)
            }
            .customShortcut(index: index) {
                if(index < 3) {
                    self.hotkeys[index].keyDownHandler = keyDownAction(clipText: pastedText)
                }
            }
        }
    }
    
    func keyDownAction(clipText: String) -> () -> () {
        return {
            print("global clipText = \(clipText)")
            copyToClipBoard(clipText: clipText)
        }
    }
    
    private func fetchAll() -> [Clips] {
        let request = Clips.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Clips.timestamp, ascending: false)]
        do {
            return try dbContext.fetch(request)
        } catch {
            print("fetch Clips error: \(error)")
            return []
        }
    }
    
    func copyToClipBoard(clipText: String) {
        print("copyToClipBoard = \(clipText)")
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([clipText as NSString])
    }
    
    func editClipBoard() {
        //클립보드 수정 페이지를 보여준다
    }
}

extension View {
    
    func customShortcut(index: Int, action:@escaping ()->()) -> some View {
        if index < 9 {
            action()
            return AnyView(self.keyboardShortcut(KeyEquivalent(Character(String(index+1)))))
        } else {
            return AnyView(self)
        }
    }
}

//struct ExtraViewClipListView_Previews: PreviewProvider {
//
//    @StateObject var clipsData = ClipsData.shared
//    static var previews: some View {
//        ExtraViewClipListView(listOfClips: ExtraClips())
//            .environment(\.managedObjectContext, clipsData.container.viewContext)
//    }
//}
