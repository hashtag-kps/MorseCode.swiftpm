//
//  Characters.swift
//  Morse Code
//
//  Created by Kavyansh on 17.02.2025.
//
import Foundation

enum Morse {
    case dot
    case line
}

struct Character: Hashable, Identifiable {
    var id = UUID()
    
    let character: String
    let morse: [Morse]
    let word: String?
}

struct CharacterProvider {
    static let alphabetical: [Character] = {
        return byDifficulty.sorted { c1, c2 in
            c1.character < c2.character
        }
    }()
    
    static let byDifficulty: [Character] = [
        Character(character: "E",
                       morse: [.dot],
                       word: "Eagle"),
            
            Character(character: "T",
                      morse: [.line],
                      word: "Tiger"),
            
            Character(character: "A",
                      morse: [.dot, .line],
                      word: "Arrow"),
            
            Character(character: "O",
                      morse: [.line, .line, .line],
                      word: "Ocean"),
            
            Character(character: "N",
                      morse: [.line, .dot],
                      word: "Ninja"),
            
            Character(character: "I",
                      morse: [.dot, .dot],
                      word: "Iceberg"),
            
            Character(character: "S",
                      morse: [.dot, .dot, .dot],
                      word: "Sunset"),
            
            Character(character: "H",
                      morse: [.dot, .dot, .dot, .dot],
                      word: "Halo"),
            
            Character(character: "R",
                      morse: [.dot, .line, .dot],
                      word: "Rocket"),
            
            Character(character: "D",
                      morse: [.line, .dot, .dot],
                      word: "Dolphin"),
            
            Character(character: "L",
                      morse: [.dot, .line, .dot, .dot],
                      word: "Lighthouse"),
            
            Character(character: "U",
                      morse: [.dot, .dot, .line],
                      word: "Umbrella"),
            
            Character(character: "W",
                      morse: [.dot, .line, .line],
                      word: "Whale"),
            
            Character(character: "K",
                      morse: [.line, .dot, .line],
                      word: "Kite"),
            
            Character(character: "G",
                      morse: [.line, .line, .dot],
                      word: "Guitar"),
            
            Character(character: "M",
                      morse: [.line, .line],
                      word: "Mountain"),
            
            Character(character: "Y",
                      morse: [.line, .dot, .line, .line],
                      word: "Yacht"),
            
            Character(character: "P",
                      morse: [.dot, .line, .line, .dot],
                      word: "Pineapple"),
            
            Character(character: "B",
                      morse: [.line, .dot, .dot, .dot],
                      word: "Butterfly"),
            
            Character(character: "V",
                      morse: [.dot, .dot, .dot, .line],
                      word: "Violin"),
            
            Character(character: "C",
                      morse: [.line, .dot, .line, .dot],
                      word: "Cactus"),
            
            Character(character: "F",
                      morse: [.dot, .dot, .line, .dot],
                      word: "Feather"),
            
            Character(character: "J",
                      morse: [.dot, .line, .line, .line],
                      word: "Jellyfish"),
            
            Character(character: "Q",
                      morse: [.line, .line, .dot, .line],
                      word: "Quartz"),
            
            Character(character: "X",
                      morse: [.line, .dot, .dot, .line],
                      word: "Xylophone"),
            
            Character(character: "Z",
                      morse: [.line, .line, .dot, .dot],
                      word: "Zebra")
    ]
    
    func forLetter(_ letter: String) -> Character {
        CharacterProvider.byDifficulty.first { $0.character == letter } ?? CharacterProvider.byDifficulty[0]
    }
}
