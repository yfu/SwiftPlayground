//
//  Utilities.swift
//  Flashzilla
//
//  Created by Yu Fu on 3/20/22.
//

import Foundation

func getDocumentDirectory() -> URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0]
}

func getDataURL(for name: String) -> URL {
    return getDocumentDirectory()
        .appendingPathComponent(name + ".json")
}

func save(_ cards: [Card]) {
    let cardsURL = getDataURL(for: "cards")
    let data = try? JSONEncoder().encode(cards)
    try? data?.write(to: cardsURL, options: [.atomic, .completeFileProtection])
    print("Saved to \(cardsURL)")
}

func load(_ name: String) -> [Card] {
    // Just load [Card] for now. Can generalize to load any data types
    let url = getDataURL(for: name)
    let data = try? Data(contentsOf: url)
    var cards = [Card]()
    if let data = data {
        do {
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            print("Cannot decode cards from json")
        }
    }
    print("Loaded from \(url)")

    return cards
}
