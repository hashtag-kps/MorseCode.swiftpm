//
//  Line.swift
//  Morse Code
//
//  Created by Kavyansh on 20.02.2025.
//


import SwiftUI

struct Line: View {
    var body: some View {
        ZStack {
            Rectangle()
                .tint(.primary)
                .frame(width: 24, height: 6)
                .cornerRadius(3)
                .clipped()
        }
        
        .frame(width: 28, height: 24)
    }
}
