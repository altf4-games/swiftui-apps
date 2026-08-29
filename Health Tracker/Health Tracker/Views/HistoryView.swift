//
//  HistoryView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData
import Charts

private enum HistoryKind: String, CaseIterable, Identifiable {
    case water = "Water"
    case weight = "Weight"
    var id: String { rawValue }
}

struct HistoryView: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @AppStorage("heightCM") private var heightCM: Double = 170

    @Query(sort: \WeightEntry.date, order: .forward) private var weightEntries: [WeightEntry]
    @Query(sort: \WaterEntry.date, order: .forward) private var waterEntries: [WaterEntry]
    @Environment(\.modelContext) private var modelContext

    @State private var kind: HistoryKind = .water

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("History Type", selection: $kind) {
                    ForEach(HistoryKind.allCases) { kind in
                        Text(kind.rawValue).tag(kind)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)

                Group {
                    switch kind {
                    case .water: waterList
                    case .weight: weightList
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("History")
        }
    }

    // MARK: Water

    @ViewBuilder
    private var waterList: some View {
        if waterEntries.isEmpty {
            ContentUnavailableView(
                "No Water Logged",
                systemImage: "drop",
                description: Text("Log your first glass of water to see it here.")
            )
        } else {
            List {
                if dailyWaterTotals.count > 1 {
                    waterChart
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                }

                Section("Log") {
                    ForEach(waterEntries.reversed()) { entry in
                        waterRow(for: entry)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
    }

    private var dailyWaterTotals: [(date: Date, total: Int)] {
        let grouped = Dictionary(grouping: waterEntries) { Calendar.current.startOfDay(for: $0.date) }
        return grouped
            .map { (date: $0.key, total: $0.value.reduce(0) { $0 + $1.amountML }) }
            .sorted { $0.date < $1.date }
    }

    private var waterChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Intake")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Chart(dailyWaterTotals, id: \.date) { entry in
                BarMark(
                    x: .value("Date", entry.date, unit: .day),
                    y: .value("ml", entry.total)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(4)
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4))
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private func waterRow(for entry: WaterEntry) -> some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundStyle(.blue)
            Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                .font(.subheadline.weight(.medium))
            Spacer()
            Text("\(entry.amountML) ml")
                .font(.body.weight(.semibold).monospacedDigit())
        }
        .padding(.vertical, 6)
        .swipeActions {
            Button(role: .destructive) {
                modelContext.delete(entry)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: Weight

    @ViewBuilder
    private var weightList: some View {
        if weightEntries.isEmpty {
            ContentUnavailableView(
                "No Entries Yet",
                systemImage: "chart.line.uptrend.xyaxis",
                description: Text("Log your first weight to see your trend here.")
            )
        } else {
            List {
                if weightEntries.count > 1 {
                    weightChart
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 8)
                }

                Section("Log") {
                    ForEach(weightEntries.reversed()) { entry in
                        weightRow(for: entry)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
    }

    private var weightChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weight Trend")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Chart(weightEntries) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", Convert.kgToDisplay(entry.weightKG, unitSystem))
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.pink)

                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", Convert.kgToDisplay(entry.weightKG, unitSystem))
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.linearGradient(colors: [.pink.opacity(0.25), .pink.opacity(0)], startPoint: .top, endPoint: .bottom))
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4))
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private func weightRow(for entry: WeightEntry) -> some View {
        let bmi = BMI.value(weightKG: entry.weightKG, heightCM: heightCM)
        let category = BMICategory(bmi: bmi)
        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.subheadline.weight(.medium))
                Text(category.label)
                    .font(.caption)
                    .foregroundStyle(category.color)
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(String(format: "%.1f", Convert.kgToDisplay(entry.weightKG, unitSystem)))
                    .font(.body.weight(.semibold).monospacedDigit())
                Text(unitSystem.weightUnit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
        .swipeActions {
            Button(role: .destructive) {
                modelContext.delete(entry)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [WeightEntry.self, WaterEntry.self], inMemory: true)
}
