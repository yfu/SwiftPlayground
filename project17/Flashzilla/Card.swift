//
//  Card.swift
//  Flashzilla
//
//  Created by Paul Hudson on 09/01/2022.
//

import Foundation


struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    let prompt: String
    let answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    func duplicate() -> Card {
        return Card(id: UUID(), prompt: self.prompt, answer: self.answer)
    }
}
