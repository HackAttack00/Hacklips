//
//  ExtraClips.swift
//  Hacklips
//
//  Created by Seungchul Lee on 2023/03/17.
//

import Foundation

class ExtraClips: ObservableObject {
    @Published var clips: [ExtraClip]?
    
    init(clips: [ExtraClip]? = []) {
        self.clips = clips
    }
    
    func appendClip(pastedText: String? = "", timestamp: Date? = Date()) {
        let clip = ExtraClip(pastedText: pastedText, timestamp: timestamp)
        self.clips?.append(clip)
//        _ = self.clips?.map({ extraClip in
//            print("extraClip.pastedText = " + extraClip.pastedText! );
//        })
    }
}

class ExtraClip: Identifiable {
    var pastedText: String?
    var timestamp: Date?

    init(pastedText: String? = nil, timestamp: Date? = nil) {
        self.pastedText = pastedText
        self.timestamp = timestamp
    }
}
