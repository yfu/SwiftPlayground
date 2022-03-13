//
//  Utilities.swift
//  HotProspects
//
//  Created by Yu Fu on 3/13/22.
//

import Foundation

func getDocumentDirectory() -> URL {
//    if let encoded = try? JSONEncoder().encode(people) {
//        UserDefaults.standard.set(encoded, forKey: saveKey)
//    }
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
