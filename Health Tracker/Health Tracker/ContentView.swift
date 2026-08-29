//
//  ContentView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasProfile") private var hasProfile: Bool = false

    var body: some View {
        if hasProfile {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                BMIView()
                    .tabItem { Label("BMI", systemImage: "gauge.with.dots.needle.50percent") }
                WaterView()
                    .tabItem { Label("Water", systemImage: "drop.fill") }
                HistoryView()
                    .tabItem { Label("History", systemImage: "chart.line.uptrend.xyaxis") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .tint(.pink)
        } else {
            ProfileSetupView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [WeightEntry.self, WaterEntry.self], inMemory: true)
}
