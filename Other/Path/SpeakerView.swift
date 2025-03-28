//
//  SpeakerView.swift
//  Morse Code
//
//  Created by Kavyansh on 20.02.2025.
//

import SwiftUI

struct SpeakerView: View {
    @State var rotation: CGFloat = 0
    @Binding var isPlaying: Bool
    
    var body: some View {
        Speaker()
            .rotation(.degrees(rotation))
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.blue)
    }
}
