//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Paul Hudson on 25/01/2022.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        let resortArray = UserDefaults.standard.object(forKey: self.saveKey) as? Array<String> ?? []
        resorts = Set(resortArray)
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        let resortArray = Array(resorts)
        UserDefaults.standard.set(resortArray, forKey: saveKey)
    }
}
