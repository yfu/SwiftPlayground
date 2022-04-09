//
//  MilestoneChallengeApp.swift
//  Shared
//
//  Created by Yu Fu on 4/2/22.
//

import SwiftUI

@main
struct MilestoneChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
