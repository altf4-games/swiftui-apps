//
//  ProfileSetupView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct ProfileSetupView: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @AppStorage("heightCM") private var heightCM: Double = 170
    @AppStorage("hasProfile") private var hasProfile: Bool = false

    @Environment(\.modelContext) private var modelContext

    @State private var heightText = ""
    @State private var weightText = ""

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 10) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 46))
                    .foregroundStyle(.pink.gradient)
                Text("Welcome")
                    .font(.largeTitle.weight(.bold))
                Text("Let's set up your profile to start tracking your BMI.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 16) {
                Picker("Units", selection: $unitSystemRaw) {
                    ForEach(UnitSystem.allCases) { system in
                        Text(system.label).tag(system.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 32)

                fieldCard(title: "Height (\(unitSystem.heightUnit))", text: $heightText, systemImage: "ruler")
                fieldCard(title: "Current weight (\(unitSystem.weightUnit))", text: $weightText, systemImage: "scalemass")
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                save()
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .disabled(!isValid)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var isValid: Bool {
        Double(heightText) != nil && Double(weightText) != nil
    }

    private func fieldCard(title: String, text: Binding<String>, systemImage: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .foregroundStyle(.pink)
                .frame(width: 24)
            TextField(title, text: text)
                .keyboardType(.decimalPad)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private func save() {
        guard let h = Double(heightText), let w = Double(weightText) else { return }
        heightCM = Convert.displayToCM(h, unitSystem)
        let weightKG = Convert.displayToKG(w, unitSystem)
        modelContext.insert(WeightEntry(weightKG: weightKG))
        hasProfile = true
    }
}

#Preview {
    ProfileSetupView()
}
