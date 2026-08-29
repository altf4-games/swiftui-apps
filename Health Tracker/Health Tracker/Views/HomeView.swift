//
//  HomeView.swift
//  Health Tracker
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @AppStorage("unitSystem") private var unitSystemRaw = UnitSystem.metric.rawValue
    @AppStorage("heightCM") private var heightCM: Double = 170
    @AppStorage("dailyWaterGoalML") private var dailyGoalML: Double = 2000

    @Query(sort: \WeightEntry.date, order: .reverse) private var weightEntries: [WeightEntry]
    @Query(sort: \WaterEntry.date, order: .reverse) private var waterEntries: [WaterEntry]

    @State private var showingAddWeightSheet = false

    private var unitSystem: UnitSystem { UnitSystem(rawValue: unitSystemRaw) ?? .metric }
    private var latestWeight: WeightEntry? { weightEntries.first }
    private var currentBMI: Double {
        guard let latestWeight else { return 0 }
        return BMI.value(weightKG: latestWeight.weightKG, heightCM: heightCM)
    }
    private var todayWaterTotal: Int {
        waterEntries
            .filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.amountML }
    }
    private var waterFraction: Double {
        guard dailyGoalML > 0 else { return 0 }
        return min(Double(todayWaterTotal) / dailyGoalML, 1)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header

                    HStack(spacing: 14) {
                        bmiSummaryCard
                        waterSummaryCard
                    }

                    HStack(spacing: 14) {
                        statCard(
                            title: "Weight",
                            value: latestWeight.map { String(format: "%.1f", Convert.kgToDisplay($0.weightKG, unitSystem)) } ?? "—",
                            unit: unitSystem.weightUnit,
                            icon: "scalemass.fill"
                        )
                        statCard(
                            title: "Height",
                            value: String(format: "%.0f", Convert.cmToDisplay(heightCM, unitSystem)),
                            unit: unitSystem.heightUnit,
                            icon: "ruler.fill"
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddWeightSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .tint(.pink)
                }
            }
            .sheet(isPresented: $showingAddWeightSheet) {
                AddWeightSheet()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Your Health Today")
                .font(.title2.weight(.bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bmiSummaryCard: some View {
        let category = BMICategory(bmi: currentBMI)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "gauge.with.dots.needle.50percent")
                    .foregroundStyle(.pink)
                Text("BMI")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text(currentBMI > 0 ? String(format: "%.1f", currentBMI) : "—")
                .font(.system(size: 30, weight: .semibold, design: .rounded))
            Text(currentBMI > 0 ? category.label : "No data")
                .font(.caption.weight(.medium))
                .foregroundStyle(currentBMI > 0 ? category.color : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private var waterSummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.blue)
                Text("Water")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text("\(todayWaterTotal) ml")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
            ProgressView(value: waterFraction)
                .progressViewStyle(.linear)
                .tint(.blue)
            Text("\(Int(waterFraction * 100))% of \(Int(dailyGoalML)) ml")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }

    private func statCard(title: String, value: String, unit: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.pink)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.title2.weight(.semibold))
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(.quaternary))
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [WeightEntry.self, WaterEntry.self], inMemory: true)
}
