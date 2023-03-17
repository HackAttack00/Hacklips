//
//  ExtraViewClipList.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/15.
//

import SwiftUI

struct ExtraViewClipListView: View {
    @Environment(\.managedObjectContext) var dbContext
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Clips.timestamp, ascending: false)], predicate: nil, animation: .default)
//    private var listOfClips: FetchedResults<Clips>
    
//    @State var listOfClips: [Clips]
    @StateObject var listOfClips = ExtraClips()
    var body: some View {
        VStack {
            List((listOfClips.clips?.reversed())!) { clip in
                Button(clip.pastedText ?? "") {
                    action1()
                }.keyboardShortcut("a")
            }
            
            Divider()
            Button("Add") {
                let clip = Clips(context: dbContext)
                clip.pastedText = "abc"
                clip.timestamp = Date()
                try? dbContext.save()
            }
            
            Button("refesh list") {
                let list = fetchAll()
                _ = list.map { clips in
                    listOfClips.appendClip(pastedText: clips.pastedText, timestamp: clips.timestamp)
                    //print(clips.pastedText ?? "없어?")
                }
            }
        }.onAppear {
            print("onAppear called")
//            if let extraClips = listOfClips.clips {
//                _ = extraClips.map { extraClip in
//                    print(extraClip.pastedText ?? "없어?")
//
//                }
//            }
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
    
    func action1() {
        print("action1")
    }
    
    func editClipBoard() {
        //클립보드 수정 페이지를 보여준다
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
