//
//  WeatherFormatting.swift
//  WeatherForecast
//
//  Small display helpers so views stay declarative.
//

import Foundation

enum WeatherFormat {
    /// "18°" — rounded, no decimals, degree sign.
    static func temperature(_ celsius: Double) -> String {
        "\(Int(celsius.rounded()))°"
    }

    /// "18.3 °C" — one decimal, used where precision reads better.
    static func temperaturePrecise(_ celsius: Double) -> String {
        String(format: "%.1f °C", celsius)
    }

    /// "12 km/h"
    static func wind(_ kmh: Double) -> String {
        "\(Int(kmh.rounded())) km/h"
    }

    /// "72%"
    static func percent(_ value: Int) -> String {
        "\(value)%"
    }

    static let weekday: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }()

    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f
    }()

    static let time: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()

    static func relativeUpdated(_ date: Date) -> String {
        "Updated " + time.string(from: date)
    }
}
