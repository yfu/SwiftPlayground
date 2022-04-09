//
//  Dice.swift
//  MilestoneChallenge
//
//  Created by Yu Fu on 4/2/22.
//

import Foundation

struct Dice: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var sides: Int
    var number = 0
    var history = Array<Int>()
    
    mutating func roll() {
        number = Array<Int>(1...sides).randomElement() ?? 0
        history.append(number)
        save()
    }
    
    mutating func flicker() {
        // Changes the number but does not actually save the number to history
        number = Array<Int>(1...sides).randomElement() ?? 0
    }
    
    mutating func setSides(to newSides: Int) {
        sides = newSides
    }
    
    var total: Int {
        history.reduce(0, +)
    }
    
    mutating func reset() {
        sides = 6
        number = 0
        history = Array<Int>()
    }
    
    init() {
        let dir = documentDirectory()
        let url = dir.appendingPathComponent("dice.json")
        guard let data = try? Data(contentsOf: url) else {
            sides = 6
            print("Cannot load from json. Setting up a default dice.")
            return
        }
        let decoded = try? JSONDecoder().decode(Dice.self, from: data)
        self = decoded!
    }
    
    func save() {
        let dir = documentDirectory()
        let url = dir.appendingPathComponent("dice.json")
        let data = try? JSONEncoder().encode(self)
        try? data?.write(to: url, options: .atomic)
        print("Saved dice to json")
        print(url)
    }
}
