//
//  AddWeightSheet.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct AddWeightSheet: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var weightText = ""
    @State private var date = Date.now
    @FocusState private var focused: Bool

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                VStack(spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        TextField("0.0", text: $weightText)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 56, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 100)
                            .fixedSize()
                            .focused($focused)
                        Text(unitSystem.weightUnit)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 12)

                DatePicker("Date", selection: $date, in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(16)
                    .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
                    .padding(.horizontal, 24)

                Spacer()

                Button {
                    save()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .disabled(Double(weightText) == nil)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Log Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear { focused = true }
        }
        .presentationDetents([.medium])
    }

    private func save() {
        guard let value = Double(weightText) else { return }
        let kg = Convert.displayToKG(value, unitSystem)
        modelContext.insert(WeightEntry(date: date, weightKG: kg))
        dismiss()
    }
}

#Preview {
    AddWeightSheet()
}
