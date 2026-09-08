//
//  WeatherCondition.swift
//  WeatherForecast
//
//  Maps WMO weather-interpretation codes (what Open-Meteo returns) to a
//  human label and an SF Symbol so the UI never deals with raw numbers.
//

import Foundation

struct WeatherCondition: Hashable {
    let code: Int
    let text: String
    let symbolName: String

    /// SF Symbol that renders nicely in multicolor.
    static func from(code: Int) -> WeatherCondition {
        switch code {
        case 0:
            return .init(code: code, text: "Clear sky", symbolName: "sun.max.fill")
        case 1:
            return .init(code: code, text: "Mainly clear", symbolName: "sun.max.fill")
        case 2:
            return .init(code: code, text: "Partly cloudy", symbolName: "cloud.sun.fill")
        case 3:
            return .init(code: code, text: "Overcast", symbolName: "cloud.fill")
        case 45, 48:
            return .init(code: code, text: "Fog", symbolName: "cloud.fog.fill")
        case 51, 53, 55:
            return .init(code: code, text: "Drizzle", symbolName: "cloud.drizzle.fill")
        case 56, 57:
            return .init(code: code, text: "Freezing drizzle", symbolName: "cloud.sleet.fill")
        case 61, 63, 65:
            return .init(code: code, text: "Rain", symbolName: "cloud.rain.fill")
        case 66, 67:
            return .init(code: code, text: "Freezing rain", symbolName: "cloud.sleet.fill")
        case 71, 73, 75:
            return .init(code: code, text: "Snowfall", symbolName: "cloud.snow.fill")
        case 77:
            return .init(code: code, text: "Snow grains", symbolName: "cloud.snow.fill")
        case 80, 81, 82:
            return .init(code: code, text: "Rain showers", symbolName: "cloud.heavyrain.fill")
        case 85, 86:
            return .init(code: code, text: "Snow showers", symbolName: "cloud.snow.fill")
        case 95:
            return .init(code: code, text: "Thunderstorm", symbolName: "cloud.bolt.rain.fill")
        case 96, 99:
            return .init(code: code, text: "Thunderstorm with hail", symbolName: "cloud.bolt.rain.fill")
        default:
            return .init(code: code, text: "Unknown", symbolName: "questionmark.circle")
        }
    }
}
