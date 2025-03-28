//
//  ToastModifier.swift
//  Morse Code
//
//  Created by Kavyansh on 20.02.2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var viewModel: ToastModel?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                VStack {
                    ToastView(viewModel: $viewModel)
                    Spacer()
                }
            }
    }
}
