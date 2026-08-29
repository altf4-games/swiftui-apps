//
//  SettingsView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @AppStorage("heightCM") private var heightCM: Double = 170
    @AppStorage("dailyWaterGoalML") private var dailyGoalML: Double = 2000

    @Environment(\.modelContext) private var modelContext
    @Query private var weightEntries: [WeightEntry]
    @Query private var waterEntries: [WaterEntry]

    @State private var heightText = ""
    @FocusState private var heightFocused: Bool
    @State private var showingResetConfirmation = false

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }

    var body: some View {
        NavigationStack {
            Form {
                Section("Units") {
                    Picker("System", selection: $unitSystemRaw) {
                        ForEach(UnitSystem.allCases) { system in
                            Text(system.label).tag(system.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Profile") {
                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("Height", text: $heightText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($heightFocused)
                            .frame(width: 80)
                        Text(unitSystem.heightUnit)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Hydration") {
                    HStack {
                        Text("Daily Goal")
                        Spacer()
                        Text("\(Int(dailyGoalML)) ml")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        Text("Delete All Data")
                    }
                    .disabled(weightEntries.isEmpty && waterEntries.isEmpty)
                } footer: {
                    Text("Removes all logged weight and water entries. This cannot be undone.")
                }
            }
            .navigationTitle("Settings")
            .onAppear { syncHeightText() }
            .onChange(of: unitSystemRaw) { syncHeightText() }
            .onChange(of: heightFocused) { _, isFocused in
                if !isFocused, let value = Double(heightText) {
                    heightCM = Convert.displayToCM(value, unitSystem)
                }
            }
            .confirmationDialog(
                "Delete all logged data?",
                isPresented: $showingResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete All Data", role: .destructive, action: resetAllData)
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private func resetAllData() {
        for entry in weightEntries { modelContext.delete(entry) }
        for entry in waterEntries { modelContext.delete(entry) }
    }

    private func syncHeightText() {
        heightText = String(format: "%.0f", Convert.cmToDisplay(heightCM, unitSystem))
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [WeightEntry.self, WaterEntry.self], inMemory: true)
}
