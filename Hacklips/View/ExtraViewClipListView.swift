//
//  ExtraViewClipList.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/15.
//

import SwiftUI

struct ExtraViewClipListView: View {
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Clips.timestamp, ascending: false)], predicate: nil, animation: .default)
    private var listOfClips: FetchedResults<Clips>
    
    var body: some View {
        ForEach(listOfClips.indices, id: \.self) { index in
            let pastedText = listOfClips[index].pastedText ?? ""
            Button(pastedText) {
                copyToClipBoard(clipText: pastedText)
            }
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
    func customShortcut(index: Int) -> some View {
        if index < 10 {
            return self.keyboardShortcut(KeyEquivalent(Character(String(index))))
        } else {
            return self.keyboardShortcut(KeyEquivalent(Character(String(0))))
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
