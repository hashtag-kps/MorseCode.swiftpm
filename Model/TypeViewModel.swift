//
//  TypeViewModal.swift
//  Morse Code
//
//  Created by Kavyansh on 18.02.2025.
//

import Foundation
import SwiftUI
//class TypeViewModel: ObservableObject{
//    
//    //MARK: - Published Values
//    /// Complexity = Number of opened characters
//    @Published var complexity: Int = 2 {
//        didSet {
//            characterPool = CharacterProvider.byDifficulty.prefix(complexity - 1).map { $0 }
//        }
//    }
//    /// Array of letters user has opened
//    @Published var characterPool: [Character] = CharacterProvider.byDifficulty.prefix(2).map { $0 }
//    
//    /// Array of letters user has entered at least once
//    @Published var discoveredCharacters: [Character] = []
//    
//    @Published var currentHint: Character?
//
//    /// Current level
//    @Published var currentLevel: [Character]
//    
//    /// Current letter index in the first level
//    @Published var currentLevelProgress = 0 {
//        didSet {
//            if !discoveredCharacters.contains(currentLevel[self.currentLevelProgress]) {
//                updateHint()
//                discoveredCharacters.append(currentLevel[self.currentLevelProgress])
//            }
//        }
//    } // Index of currently selected letter
//
//    @Published var levelsCompleted = 0
//    @Published var wrongAnswers = 0
//
//    @Published var contextAnswerStatus = AnswerStatus.none
//    @Published var context: [Morse] = [] {
//        didSet {
//            guard self.context != [] else { return }
//
//            contextTimer.invalidate()
//            contextTimer = Timer(timeInterval: 0.25, repeats: false, block: { _ in
//                // Correct answer
//                if self.context == self.currentLevel[self.currentLevelProgress].morse {
//                    if self.currentLevelProgress == self.currentLevel.count - 1 {
//                        self.levelsCompleted += 1
//                        // Necessary for opacity transition
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                            self.loadNewLevel()
//                            self.currentLevelProgress = 0
//                        }
//                    } else {
//                        withAnimation(.interpolatingSpring(mass: 0.04, stiffness: 10.0, damping: 0.7, initialVelocity: 8.0)) {
//                            self.currentLevelProgress += 1
//                        }
//                    }
//
//                    self.contextAnswerStatus = .correct
//
//                    // Reset field
//                    self.context = []
//                    self.contextTimer.invalidate()
//                } else {
//
//
//                    // Wrong answer
//                    self.contextAnswerStatus = .wrong
//                    self.wrongAnswers += 1
//                    self.updateHint()
//
//                    // Error Haptic Feedback
//                    let generator = UINotificationFeedbackGenerator()
//                    generator.notificationOccurred(.error)
//
//                    // Reset field
//                    self.context = []
//                }
//            })
//
//            let fireDate = self.context == self.currentLevel[self.currentLevelProgress].morse ? 0.3 : 0.8
//            self.contextTimer.fireDate = .now + fireDate
//            RunLoop.main.add(self.contextTimer, forMode: .common)
//        }
//    }
//
//    @Published var toast: ToastModel?
//    var toastMessage = ["Congrats!",
//                        "You did it!",
//                        "Next level 💪",
//                        "Keep working!",
//                        "Keep going!",
//                        "Amazing!",
//                        "Great work!",
//                        "Keep it up!",
//                        "Love it 👍",
//                        "Proud of you!"]
//
//    var contextTimer = Timer()
//    
//    init() {
//        currentLevel = [CharacterProvider().forLetter("E"), /// First level template
//                                       CharacterProvider().forLetter("E"),
//                                       CharacterProvider().forLetter("E")]
//        updateHint()
//    }
//
//    func loadNewLevel() {
//        self.currentLevel = []
//
//        if self.levelsCompleted % 2 == 0 {
//            self.complexity += 1
//            self.toast = ToastModel(symbol: "checkmark.circle.fill", text: self.toastMessage.randomElement()!)
//        }
//
//        var numbersVolume = 2
//        if self.complexity > 5 {
//            numbersVolume = 3
//        } else if self.complexity > 10 {
//            numbersVolume = 4
//        }
//        for _ in 0...numbersVolume {
//            self.currentLevel.append(self.characterPool.randomElement() ?? CharacterProvider().forLetter("E"))
//        }
//    }
//    
//    func updateHint() {
//        currentHint = currentLevel[currentLevelProgress]
//    }
//}


@MainActor
final class TypeViewModel: ObservableObject {
    // MARK: - Published Values
    @Published private(set) var complexity: Int = 2 {
        didSet {
            Task {
                let chars = await CharacterProvider.byDifficulty
                characterPool = Array(chars.prefix(complexity - 1))
            }
        }
    }
    
    @Published private(set) var characterPool: [Character] = []
    @Published private(set) var discoveredCharacters: [Character] = []
    @Published var currentHint: Character?
    @Published private(set) var currentLevel: [Character]
    @Published private(set) var currentLevelProgress = 0 {
        didSet {
            guard currentLevelProgress < currentLevel.count else { return }
            if !discoveredCharacters.contains(where: { $0.character == currentLevel[currentLevelProgress].character }) {
                updateHint()
                discoveredCharacters.append(currentLevel[currentLevelProgress])
            }
        }
    }
    
    @Published private(set) var levelsCompleted = 0
    @Published var wrongAnswers = 0
    @Published private(set) var contextAnswerStatus = AnswerStatus.none
    @Published var context: [Morse] = [] {
        didSet {
            handleContextChange()
        }
    }
    
    @Published var toast: ToastModel?
    
    private let toastMessage = [
        "Congrats!", "You did it!", "Next level 💪",
        "Keep working!", "Keep going!", "Amazing!",
        "Great work!", "Keep it up!", "Love it 👍",
        "Proud of you!"
    ]
    
    private var contextTimer = Timer()
    private let characterProvider: CharacterProvider
    
    init() {
        self.characterProvider = CharacterProvider()
        self.currentLevel = []
        
        Task {
            let initial = await characterProvider.forLetter("E")
            self.currentLevel = Array(repeating: initial, count: 3)
            await self.initializeCharacterPool()
            self.updateHint()
        }
    }
    
    private func initializeCharacterPool() async {
        let chars = await CharacterProvider.byDifficulty
        characterPool = Array(chars.prefix(2))
    }
    
    private func handleContextChange() {
        guard !context.isEmpty else { return }
        
        contextTimer.invalidate()
        
        let isCorrectAnswer = context == currentLevel[currentLevelProgress].morse
        let delay = isCorrectAnswer ? 0.3 : 0.8
        
        contextTimer = Timer(timeInterval: 0.25, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                await self.processAnswer(isCorrect: isCorrectAnswer)
            }
        }
        
        contextTimer.fireDate = .now + delay
        RunLoop.main.add(contextTimer, forMode: .common)
    }
    
    private func processAnswer(isCorrect: Bool) async {
        if isCorrect {
            await handleCorrectAnswer()
        } else {
            await handleWrongAnswer()
        }
        context = []
    }
    
    private func handleCorrectAnswer() async {
        if currentLevelProgress == currentLevel.count - 1 {
            levelsCompleted += 1
            try? await Task.sleep(nanoseconds: 250_000_000) // 0.25 seconds
            await loadNewLevel()
            currentLevelProgress = 0
        } else {
            withAnimation(.interpolatingSpring(mass: 0.04, stiffness: 10.0, damping: 0.7, initialVelocity: 8.0)) {
                currentLevelProgress += 1
            }
        }
        contextAnswerStatus = .correct
        contextTimer.invalidate()
    }
    
    private func handleWrongAnswer() async {
        contextAnswerStatus = .wrong
        wrongAnswers += 1
        updateHint()
        
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    func loadNewLevel() async {
        currentLevel.removeAll()
        
        if levelsCompleted % 2 == 0 {
            complexity += 1
            toast = ToastModel(symbol: "checkmark.circle.fill", text: toastMessage.randomElement() ?? "Great job!")
        }
        
        let numbersVolume = complexity > 10 ? 4 : (complexity > 5 ? 3 : 2)
        
        for _ in 0...numbersVolume {
            if let randomChar = characterPool.randomElement() {
                currentLevel.append(randomChar)
            } else {
                let defaultChar = await characterProvider.forLetter("E")
                currentLevel.append(defaultChar)
            }
        }
    }
    
     func updateHint() {
        guard currentLevelProgress < currentLevel.count else { return }
        currentHint = currentLevel[currentLevelProgress]
    }
}
