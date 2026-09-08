//
//  ForecastView.swift
//  WeatherForecast
//
//  Screen 3 — Weather Forecast.
//  The multi-day outlook as a list: weekday, icon, precipitation chance,
//  and high / low temperatures. Pull to refresh.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var vm: WeatherViewModel

    var body: some View {
        Group {
            if let report = vm.report, !report.daily.isEmpty {
                List {
                    Section {
                        ForEach(Array(report.daily.enumerated()), id: \.element.id) { index, day in
                            ForecastRow(day: day, isToday: index == 0)
                        }
                    } header: {
                        Text("\(report.daily.count)-day outlook for \(report.place.name)")
                    } footer: {
                        Text(WeatherFormat.relativeUpdated(report.retrievedAt))
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable { await vm.refresh() }
            } else {
                ContentUnavailableView("No forecast",
                                       systemImage: "calendar.badge.exclamationmark",
                                       description: Text("Search for a city to see its forecast."))
            }
        }
        .navigationTitle("7-Day Forecast")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await vm.refresh() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(vm.isLoading)
            }
        }
    }
}
