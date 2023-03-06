//
//  ClipsMainView.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import SwiftUI

struct ClipsMainView: View {    
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Clips.timestamp, ascending: true)], predicate: nil, animation: .default)
    private var listOfClips: FetchedResults<Clips>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfClips) { clip in
                    RowClip(clip: clip)
                }
            }
            .toolbar {
                //ios분기
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: DetailClipView()) {
//                        Image(systemName: "plus")
//                    }
//                }
                
                ToolbarItem {
                    Button(action: addItem) {
                        
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.onAppear {
            let watcher = ClipboardWatcher()
            watcher.startWatcher()
        }
    }
    
    private func addItem() {
        print("clip 추가")
        
        if let lastPastedString = ClipsData.getLastCopiedString() {
            print("lastPastedString = \(lastPastedString)")
            
            saveClip(clipText: lastPastedString)
        } else {
            print("no clip!")
        }
    }
    
    func saveClip(clipText: String) {
        Task(priority: .high) {
            await ClipsData.shared.saveClip(clipText: clipText)
        }
    }
}

struct RowClip: View {
    let clip: Clips
    
    var body: some View {
        Text(clip.pastedText ?? "null")
            .bold()
    }
}



struct ClipsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClipsMainView()
    }
}
