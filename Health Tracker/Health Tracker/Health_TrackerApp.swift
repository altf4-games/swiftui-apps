//
//  Health_TrackerApp.swift
//  Health Tracker
//
//  Created by Pradyum Mistry on 25/08/26.
//

import SwiftUI
import SwiftData

@main
struct Health_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [WeightEntry.self, WaterEntry.self])
    }
}
