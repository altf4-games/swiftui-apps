//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Owns the search text, the async load lifecycle, the current report, and
//  the list of recently searched cities (persisted in UserDefaults).
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {

    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published var query: String = ""
    @Published private(set) var phase: Phase = .idle
    @Published private(set) var report: WeatherReport?
    @Published private(set) var recentCities: [String] = []

    private let service: WeatherService
    private let recentsKey = "recentCities"
    private let maxRecents = 8

    init(service: WeatherService? = nil) {
        self.service = service ?? WeatherService()
        self.recentCities = UserDefaults.standard.stringArray(forKey: recentsKey) ?? []
    }

    var isLoading: Bool { phase == .loading }

    var errorMessage: String? {
        if case .failed(let message) = phase { return message }
        return nil
    }

    // MARK: - Actions

    /// Search for whatever is currently in `query`. Returns true on success so
    /// the view can push the details screen.
    @discardableResult
    func search() async -> Bool {
        await load { try await service.report(for: query) }
    }

    /// Search for a specific city name (tapped from the recents list).
    @discardableResult
    func search(city: String) async -> Bool {
        query = city
        return await search()
    }

    /// Re-fetch the currently displayed place without going through geocoding.
    func refresh() async {
        guard let place = report?.place else { return }
        await load { try await service.report(for: place) }
    }

    // MARK: - Plumbing

    @discardableResult
    private func load(_ operation: () async throws -> WeatherReport) async -> Bool {
        phase = .loading
        do {
            let report = try await operation()
            self.report = report
            self.phase = .loaded
            remember(report.place.name)
            return true
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? "Something went wrong. Please try again."
            self.phase = .failed(message)
            return false
        }
    }

    private func remember(_ city: String) {
        let name = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        recentCities.removeAll { $0.caseInsensitiveCompare(name) == .orderedSame }
        recentCities.insert(name, at: 0)
        if recentCities.count > maxRecents {
            recentCities = Array(recentCities.prefix(maxRecents))
        }
        UserDefaults.standard.set(recentCities, forKey: recentsKey)
    }

    func clearRecents() {
        recentCities.removeAll()
        UserDefaults.standard.removeObject(forKey: recentsKey)
    }
}
