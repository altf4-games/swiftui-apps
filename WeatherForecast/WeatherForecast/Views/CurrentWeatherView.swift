//
//  CurrentWeatherView.swift
//  WeatherForecast
//
//  Screen 2 — Current Weather Details.
//  Big temperature, condition + icon, and a grid of details (feels-like,
//  humidity, wind). Pull to refresh or use the toolbar button.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var vm: WeatherViewModel
    @Binding var path: [Route]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        Group {
            if let report = vm.report {
                content(for: report)
            } else {
                ContentUnavailableView("No weather loaded",
                                       systemImage: "cloud",
                                       description: Text("Go back and search for a city."))
            }
        }
        .navigationTitle(vm.report?.place.name ?? "Weather")
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

    private func content(for report: WeatherReport) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                hero(for: report)

                if let error = vm.errorMessage {
                    ErrorBanner(message: error) {
                        Task { await vm.refresh() }
                    }
                }

                LazyVGrid(columns: columns, spacing: 12) {
                    DetailTile(icon: "thermometer.medium",
                               title: "Feels like",
                               value: WeatherFormat.temperature(report.current.feelsLikeC))
                    DetailTile(icon: "humidity.fill",
                               title: "Humidity",
                               value: WeatherFormat.percent(report.current.humidity))
                    DetailTile(icon: "wind",
                               title: "Wind speed",
                               value: WeatherFormat.wind(report.current.windSpeedKMH))
                    DetailTile(icon: "location.fill",
                               title: "Coordinates",
                               value: String(format: "%.2f, %.2f",
                                             report.place.latitude, report.place.longitude))
                }

                Button {
                    path.append(.forecast)
                } label: {
                    Label("See 7-day forecast", systemImage: "calendar")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Text(WeatherFormat.relativeUpdated(report.retrievedAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .refreshable { await vm.refresh() }
    }

    private func hero(for report: WeatherReport) -> some View {
        VStack(spacing: 10) {
            Text(report.place.displayName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            WeatherIcon(condition: report.current.condition, size: 96)

            Text(WeatherFormat.temperature(report.current.temperatureC))
                .font(.system(size: 72, weight: .thin))
                .contentTransition(.numericText())

            Text(report.current.condition.text)
                .font(.title3.weight(.medium))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}
