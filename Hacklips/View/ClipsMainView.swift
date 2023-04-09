//
//  ClipsMainView.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import SwiftUI
import Cocoa
import HotKey

struct ClipsMainView: View {    
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Clips.pinned, ascending: false), NSSortDescriptor(keyPath: \Clips.timestamp, ascending: false)], predicate: nil, animation: .default)
    private var listOfClips: FetchedResults<Clips>
    
    @State private var selectedClip: Clips? = nil
    @State var index: Int = 0
    let hotkey1 = HotKey(key: .one, modifiers: [.control, .command])
    
    var body: some View {
        NavigationView {
            List (listOfClips, id: \.self, selection: $selectedClip) { clip in
  //              ForEach(listOfClips) { clip in
                    NavigationLink {
                        VStack {
                            HStack {
                                Text("\(clip.pastedText ?? "")")
                                Spacer(minLength: 10)
                            }
                            Spacer(minLength: 10)
                        }
                    } label: {
                        RowClip(clip: clip)
                    }
//                }
            }
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button(action: deleteAllClips) {
                            Label("deleteSelectedClip clips", systemImage: "trash")
                        }
                        Button(action: deleteSelectedClip) {
                            Label("deleteSelectedClip clips", systemImage: "trash.circle.fill")
                        }
                    }
                }
            }

        }.onAppear {
            let watcher = ClipboardWatcher()
            watcher.startWatcher()
            
            let pastedText = listOfClips[2].pastedText ?? ""
            hotkey1.keyDownHandler = keyDownAction(clipText: pastedText)
        }
    }
    
    func keyDownAction(clipText: String) -> () -> () {
        return {
            print("global clipText = \(clipText)")
        }
    }
    
    func doSomething() {
        print("Do something")
    }
    
    private func setSelectedClip(index:Int) {
        self.selectedClip = self.listOfClips[index]
    }
    
    private func addClip() {
        print("clip 추가")
        
        if let lastPastedString = ClipsData.getLastCopiedString() {
            print("lastPastedString = \(lastPastedString)")
            
            saveClip(clipText: lastPastedString)
        } else {
            print("no clip!")
        }
    }
    
    private func deleteAllClips() {
        print("clip 모두 삭제")
        listOfClips.forEach({ clip in
            eraseClip(clip: clip)
        })
    }
    
    private func deleteSelectedClip() {
        if let selectedClip = self.selectedClip {
            Task(priority: .high) {
                await ClipsData.shared.eraseClip(clip: selectedClip)
            }
        }
    }
    
    func saveClip(clipText: String) {
        Task(priority: .high) {
            await ClipsData.shared.saveClip(clipText: clipText)
        }
    }
    
    func eraseClip(clip: Clips) {
        Task(priority: .high) {
            await ClipsData.shared.eraseClip(clip: clip)
        }
    }
}

struct RowClip: View {
    let clip: Clips
    @State var clipTitle = ""
    @State var clipPinned = false
    @State var maxOffset = 19
    
    var body: some View {
        HStack {
            Text(self.clipTitle)
                .bold()
            Spacer()
            Button(action: togglePin(pastedText: clip.pastedText ?? "")) {
                if self.clipPinned {
                    Image(systemName: "pin.fill")
                        .imageScale(.small)
                } else {
                    Image(systemName: "pin")
                        .imageScale(.small)
                }
            }
        }
        .onAppear {
            if let pastedText = clip.pastedText {
                if pastedText.count < 20 {
                    self.maxOffset = pastedText.count - 1
                }
                
                if pastedText.count != 0 {
                    let endIndex = pastedText.index(pastedText.startIndex, offsetBy: self.maxOffset)
                    let range = ...endIndex
                    self.clipTitle = String(pastedText[range])
                    self.clipPinned = clip.pinned
                } else {
                    self.clipTitle = ""
                }
            }
        }
        
    }
    
    func togglePin(pastedText:String) ->() ->() {
        return {
            Task(priority: .high) {
                if self.clipPinned {
                    await ClipsData.shared.erasePin(clipText: pastedText)
                } else {
                    await ClipsData.shared.savePin(clipText:pastedText)
                }
            }
            print(pastedText)
        }

    }
}

struct ClipsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClipsMainView()
    }
}
