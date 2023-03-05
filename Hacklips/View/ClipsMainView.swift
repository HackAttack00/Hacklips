//
//  ClipsMainView.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import SwiftUI

struct ClipsMainView: View {    
    @Environment(\.managedObjectContext) var dbContext

    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) private var listOfClips: FetchedResults<Clips>
    
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
        }
    }
    
    private func addItem() {
        print("clip 추가")
        
        if let lastPastedString = ClipsData.getLastCopiedString() {
            print("lastPastedString = \(lastPastedString)")
            
            Task(priority: .high) {
                await saveClip(clipText: lastPastedString)
            }
        } else {
            print("no clip!")
        }
    }
    
    func saveClip(clipText: String) async {
        await dbContext.perform {
            let newClip = Clips(context: dbContext)
            newClip.pastedText = clipText
            
            do {
                try dbContext.save()
            } catch {
                print("Error saving clip")
            }
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
