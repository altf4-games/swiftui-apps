//
//  BMIView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct BMIView: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @AppStorage("heightCM") private var heightCM: Double = 170

    @Query(sort: \WeightEntry.date, order: .reverse) private var entries: [WeightEntry]
    @Environment(\.modelContext) private var modelContext

    @State private var heightText = ""
    @State private var weightText = ""
    @FocusState private var focusedField: Field?
    @State private var didSave = false

    private enum Field { case height, weight }

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }

    private var liveBMI: Double {
        guard let h = Double(heightText), let w = Double(weightText), h > 0 else { return 0 }
        let hCM = Convert.displayToCM(h, unitSystem)
        let wKG = Convert.displayToKG(w, unitSystem)
        return BMI.value(weightKG: wKG, heightCM: hCM)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    BMIGaugeView(bmi: liveBMI)
                        .frame(height: 240)
                        .padding(.top, 8)

                    VStack(spacing: 14) {
                        inputRow(title: "Height", unit: unitSystem.heightUnit, text: $heightText, field: .height, icon: "ruler.fill")
                        inputRow(title: "Weight", unit: unitSystem.weightUnit, text: $weightText, field: .weight, icon: "scalemass.fill")
                    }
                    .padding(16)
                    .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))

                    Button {
                        save()
                    } label: {
                        Label(didSave ? "Saved" : "Save Weight Entry", systemImage: didSave ? "checkmark" : "square.and.arrow.down")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(didSave ? .green : .pink)
                    .disabled(Double(heightText) == nil || Double(weightText) == nil)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("BMI")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
            .onAppear(perform: prefill)
        }
    }

    private func inputRow(title: String, unit: String, text: Binding<String>, field: Field, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.pink)
                .frame(width: 24)
            Text(title)
                .font(.subheadline.weight(.medium))
            Spacer()
            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .focused($focusedField, equals: field)
                .frame(width: 70)
            Text(unit)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func prefill() {
        heightText = String(format: "%.0f", Convert.cmToDisplay(heightCM, unitSystem))
        if let latest = entries.first {
            weightText = String(format: "%.1f", Convert.kgToDisplay(latest.weightKG, unitSystem))
        }
    }

    private func save() {
        guard let h = Double(heightText), let w = Double(weightText) else { return }
        heightCM = Convert.displayToCM(h, unitSystem)
        let weightKG = Convert.displayToKG(w, unitSystem)
        modelContext.insert(WeightEntry(weightKG: weightKG))

        didSave = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            didSave = false
        }
    }
}

#Preview {
    BMIView()
        .modelContainer(for: WeightEntry.self, inMemory: true)
}
