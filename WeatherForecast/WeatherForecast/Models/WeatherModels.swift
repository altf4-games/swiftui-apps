//
//  WeatherModels.swift
//  WeatherForecast
//
//  Codable models that mirror the Open-Meteo JSON responses, plus the
//  view-friendly types the UI actually renders.
//

import Foundation

// MARK: - Geocoding API (city name -> coordinates)

struct GeocodingResponse: Codable {
    let results: [GeocodedPlace]?
}

struct GeocodedPlace: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?      // state / region

    /// e.g. "London, England, United Kingdom"
    var displayName: String {
        [name, admin1, country]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

// MARK: - Forecast API

struct ForecastResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentBlock
    let daily: DailyBlock

    struct CurrentBlock: Codable {
        let time: String
        let temperature2m: Double
        let apparentTemperature: Double
        let relativeHumidity2m: Int
        let weatherCode: Int
        let windSpeed10m: Double

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case apparentTemperature = "apparent_temperature"
            case relativeHumidity2m = "relative_humidity_2m"
            case weatherCode = "weather_code"
            case windSpeed10m = "wind_speed_10m"
        }
    }

    struct DailyBlock: Codable {
        let time: [String]
        let weatherCode: [Int]
        let temperature2mMax: [Double]
        let temperature2mMin: [Double]
        let precipitationProbabilityMax: [Int?]

        enum CodingKeys: String, CodingKey {
            case time
            case weatherCode = "weather_code"
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
            case precipitationProbabilityMax = "precipitation_probability_max"
        }
    }
}

// MARK: - View models

/// Everything one screen-load produces: the resolved place plus current
/// conditions and a multi-day forecast.
struct WeatherReport: Identifiable, Hashable {
    let id = UUID()
    let place: GeocodedPlace
    let current: CurrentConditions
    let daily: [DailyForecast]
    let retrievedAt: Date
}

struct CurrentConditions: Hashable {
    let temperatureC: Double
    let feelsLikeC: Double
    let humidity: Int          // percent
    let windSpeedKMH: Double
    let condition: WeatherCondition
}

struct DailyForecast: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let highC: Double
    let lowC: Double
    let precipitationChance: Int?   // percent
    let condition: WeatherCondition
}
