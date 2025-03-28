//
//  ShakeEffect.swift
//  Morse Code
//
//  Created by Kavyansh on 18.02.2025.
//


import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance : CGFloat = 6
    var numOfShakes : CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
        travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}
