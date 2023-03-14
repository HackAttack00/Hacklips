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
        List(listOfClips) { clip in
          Text(clip.pastedText ?? "")
        }
        Divider()
        Button("Add") {
            let clip = Clips(context: dbContext)
            clip.pastedText = "abc"
            clip.timestamp = Date()
            try? dbContext.save()
        }
    }
    
    func editClipBoard() {
        //클립보드 수정 페이지를 보여준다
    }
}

struct ExtraViewClipListView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraViewClipListView()
    }
}
