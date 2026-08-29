//
//  WaterView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct WaterView: View {
    @AppStorage("dailyWaterGoalML") private var dailyGoalML: Double = 2000

    @Query(sort: \WaterEntry.date, order: .reverse) private var entries: [WaterEntry]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedDate = Date.now
    @State private var intakeAmount = 250
    @State private var justAdded = false

    private var totalForSelectedDate: Int {
        entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { $0 + $1.amountML }
    }

    private var progressFraction: Double {
        guard dailyGoalML > 0 else { return 0 }
        return min(Double(totalForSelectedDate) / dailyGoalML, 1)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    progressCard
                    goalCard
                    logCard
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Water")
        }
    }

    private var progressCard: some View {
        VStack(spacing: 14) {
            ProgressView(value: progressFraction)
                .progressViewStyle(.linear)
                .tint(.blue)
                .scaleEffect(x: 1, y: 2.4, anchor: .center)

            HStack(alignment: .firstTextBaseline) {
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text("\(totalForSelectedDate)")
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                    Text("/ \(Int(dailyGoalML)) ml")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(Int(progressFraction * 100))%")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }

            Text(Calendar.current.isDateInToday(selectedDate) ? "Today's hydration" : "Hydration on \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private var goalCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Daily Goal")
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(Int(dailyGoalML)) ml")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.blue)
            }
            Slider(value: $dailyGoalML, in: 500...5000, step: 100) {
                Text("Daily Goal")
            } minimumValueLabel: {
                Text("0.5L").font(.caption2).foregroundStyle(.secondary)
            } maximumValueLabel: {
                Text("5L").font(.caption2).foregroundStyle(.secondary)
            }
            .tint(.blue)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private var logCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Log Intake")
                .font(.subheadline.weight(.medium))

            DatePicker("Date", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)

            Stepper(value: $intakeAmount, in: 50...2000, step: 50) {
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundStyle(.blue)
                    Text("\(intakeAmount) ml")
                        .font(.body.weight(.semibold).monospacedDigit())
                }
            }

            Button {
                addEntry()
            } label: {
                Label(justAdded ? "Added" : "Add Entry", systemImage: justAdded ? "checkmark" : "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(justAdded ? .green : .blue)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private func addEntry() {
        modelContext.insert(WaterEntry(date: selectedDate, amountML: intakeAmount))
        justAdded = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            justAdded = false
        }
    }
}

#Preview {
    WaterView()
        .modelContainer(for: WaterEntry.self, inMemory: true)
}
