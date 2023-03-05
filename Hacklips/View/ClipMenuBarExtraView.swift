//
//  ClipMenuBarExtraView.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/05.
//

import SwiftUI

struct ClipMenuBarExtraView: View {
    var body: some View {
        Button(action: action1, label: { Text("Action 1") })
        Button(action: action2, label: { Text("Action 2") })
        
        Divider()

        Button(action: editClipBoard, label: { Text("Edit Clips") })
    }
    
    func action1() {
        if let lastPastedString = ClipsData.getLastCopiedString() {
            print("lastPastedString = \(lastPastedString)")
        }
    }
    
    func action2() {
        
    }
    
    func editClipBoard() {
        //클립보드 수정 페이지를 보여준다
    }
}

struct ClipMenuBarExtraView_Previews: PreviewProvider {
    static var previews: some View {
        ClipMenuBarExtraView()
    }
}
