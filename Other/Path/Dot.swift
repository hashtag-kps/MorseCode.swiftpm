//
//  Dot.swift
//  Morse Code
//
//  Created by Kavyansh on 20.02.2025.
//

import SwiftUI

struct Dot: View {
    var body: some View {
        ZStack {
            Circle()
                .tint(.primary)
                .frame(width: 8, height: 8)
        }
        .frame(width: 12, height: 24)
    }
}
