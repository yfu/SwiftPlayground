//
//  Prospect.swift
//  HotProspects
//
//  Created by Paul Hudson on 03/01/2022.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var date = Date()
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"

    init() {
        do {
            let data = try Data(contentsOf: Prospects.prospectsURL)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            print("Loaded from JSON")
        } catch {
            // no saved data!
            print("Cannot load from JSON")
            people = []
        }
    }

    static var prospectsURL: URL {
        let url = getDocumentDirectory()
        return url.appendingPathComponent("prospects.json")
    }
    
    private func save() {
        let encoded = try! JSONEncoder().encode(people)
        try? encoded.write(to: Prospects.prospectsURL, options: [.completeFileProtection, .atomic])
        print("Saved to \(Prospects.prospectsURL)")
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    enum SortOrder {
        case alphabetical
        case chronological
    }
    
    func get(order: SortOrder = .alphabetical) -> [Prospect] {
        switch order {
        case .alphabetical:
            return people.sorted { a, b in
                a.name < b.name
            }
        case .chronological:
            return people.sorted { a, b in
                a.date < b.date
            }
        }
    }
}
