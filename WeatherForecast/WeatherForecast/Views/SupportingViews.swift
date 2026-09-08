//
//  SupportingViews.swift
//  WeatherForecast
//
//  Small reusable pieces shared by the three screens.
//

import SwiftUI

/// Navigation targets pushed onto the SearchView's NavigationStack.
enum Route: Hashable {
    case current
    case forecast
}

/// Multicolor SF Symbol for a weather condition.
struct WeatherIcon: View {
    let condition: WeatherCondition
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: condition.symbolName)
            .symbolRenderingMode(.multicolor)
            .font(.system(size: size))
            .accessibilityLabel(condition.text)
    }
}

/// Labelled tile used in the "details" grid (humidity, wind, feels-like…).
struct DetailTile: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

/// One row in the multi-day forecast list.
struct ForecastRow: View {
    let day: DailyForecast
    let isToday: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text(isToday ? "Today" : WeatherFormat.weekday.string(from: day.date))
                    .font(.body.weight(.medium))
                Text(WeatherFormat.shortDate.string(from: day.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 96, alignment: .leading)

            WeatherIcon(condition: day.condition, size: 26)
                .frame(width: 34)

            if let precip = day.precipitationChance, precip > 0 {
                Label(WeatherFormat.percent(precip), systemImage: "drop.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }

            Spacer()

            Text(WeatherFormat.temperature(day.lowC))
                .foregroundStyle(.secondary)
            Text(WeatherFormat.temperature(day.highC))
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}

/// Full-width error banner with a retry button.
struct ErrorBanner: View {
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .font(.callout)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            if let retry {
                Button("Try Again", action: retry)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.red.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
        .foregroundStyle(.red)
    }
}
