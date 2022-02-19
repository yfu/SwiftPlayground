//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Yu Fu on 2/10/22.
//

import SwiftUI

@main
struct FriendfaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
