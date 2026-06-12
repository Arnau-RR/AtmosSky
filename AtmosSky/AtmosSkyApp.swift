//
//  AtmosSkyApp.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import SwiftUI
import SwiftData

@main
struct AtmosSkyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            //Item.self,
            FavoriteCity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
