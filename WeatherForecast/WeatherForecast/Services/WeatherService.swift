//
//  WeatherService.swift
//  WeatherForecast
//
//  Talks to the Open-Meteo REST API with URLSession, decodes the JSON with
//  Codable, and returns processed Swift models. No API key required.
//
//  Geocoding: https://geocoding-api.open-meteo.com/v1/search
//  Forecast:  https://api.open-meteo.com/v1/forecast
//

import Foundation

enum WeatherServiceError: LocalizedError {
    case emptyQuery
    case cityNotFound(String)
    case badResponse(Int)
    case network(String)
    case decoding

    var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Enter a city name to search."
        case .cityNotFound(let name):
            return "Couldn't find a place called \"\(name)\". Check the spelling and try again."
        case .badResponse(let code):
            return "The weather service responded with an error (HTTP \(code))."
        case .network(let message):
            return "Network problem: \(message)"
        case .decoding:
            return "Received an unexpected response from the weather service."
        }
    }
}

struct WeatherService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public API

    /// Full flow: resolve the city, then fetch its current weather + forecast.
    func report(for city: String, forecastDays: Int = 7) async throws -> WeatherReport {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw WeatherServiceError.emptyQuery }

        let place = try await geocode(city: trimmed)
        return try await report(for: place, forecastDays: forecastDays)
    }

    /// Fetch weather for an already-resolved place (used by "refresh").
    func report(for place: GeocodedPlace, forecastDays: Int = 7) async throws -> WeatherReport {
        let forecast = try await forecast(latitude: place.latitude,
                                         longitude: place.longitude,
                                         days: forecastDays)

        let current = CurrentConditions(
            temperatureC: forecast.current.temperature2m,
            feelsLikeC: forecast.current.apparentTemperature,
            humidity: forecast.current.relativeHumidity2m,
            windSpeedKMH: forecast.current.windSpeed10m,
            condition: .from(code: forecast.current.weatherCode)
        )

        let daily = Self.dailyForecasts(from: forecast.daily, timezone: forecast.timezone)

        return WeatherReport(place: place,
                             current: current,
                             daily: daily,
                             retrievedAt: Date())
    }

    // MARK: - Geocoding

    func geocode(city: String) async throws -> GeocodedPlace {
        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
        components.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        let decoded: GeocodingResponse = try await get(components.url!)
        guard let place = decoded.results?.first else {
            throw WeatherServiceError.cityNotFound(city)
        }
        return place
    }

    // MARK: - Forecast

    func forecast(latitude: Double, longitude: Double, days: Int) async throws -> ForecastResponse {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current",
                         value: "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m"),
            URLQueryItem(name: "daily",
                         value: "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: String(days)),
            URLQueryItem(name: "wind_speed_unit", value: "kmh"),
            URLQueryItem(name: "temperature_unit", value: "celsius")
        ]

        return try await get(components.url!)
    }

    // MARK: - Networking

    private func get<T: Decodable>(_ url: URL) async throws -> T {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw WeatherServiceError.network(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw WeatherServiceError.badResponse(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw WeatherServiceError.decoding
        }
    }

    // MARK: - Parsing helpers

    private static func dailyForecasts(from block: ForecastResponse.DailyBlock,
                                       timezone: String) -> [DailyForecast] {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd"
        parser.timeZone = TimeZone(identifier: timezone) ?? .current

        let count = min(block.time.count,
                        block.weatherCode.count,
                        block.temperature2mMax.count,
                        block.temperature2mMin.count)

        return (0..<count).compactMap { i in
            guard let date = parser.date(from: block.time[i]) else { return nil }
            let precip = i < block.precipitationProbabilityMax.count
                ? block.precipitationProbabilityMax[i]
                : nil
            return DailyForecast(
                date: date,
                highC: block.temperature2mMax[i],
                lowC: block.temperature2mMin[i],
                precipitationChance: precip,
                condition: .from(code: block.weatherCode[i])
            )
        }
    }
}
