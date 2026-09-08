//
//  SearchView.swift
//  WeatherForecast
//
//  Screen 1 — Weather Search / Home.
//  Enter a city, kick off the network request, and on success push the
//  Current Weather Details screen. Also lists recently searched cities.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = WeatherViewModel()
    @State private var path: [Route] = []
    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    searchField

                    Button {
                        Task { await runSearch() }
                    } label: {
                        Text("Get Weather")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(vm.query.trimmingCharacters(in: .whitespaces).isEmpty || vm.isLoading)

                    if vm.isLoading {
                        ProgressView("Fetching weather…")
                            .padding(.top, 8)
                    }

                    if let error = vm.errorMessage {
                        ErrorBanner(message: error) {
                            Task { await runSearch() }
                        }
                    }

                    if !vm.recentCities.isEmpty {
                        recentSection
                    }

                    Spacer(minLength: 0)
                }
                .padding()
            }
            .navigationTitle("Weather Forecast")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .current:
                    CurrentWeatherView(vm: vm, path: $path)
                case .forecast:
                    ForecastView(vm: vm)
                }
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "cloud.sun.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 64))
            Text("Search any city to see its current conditions and a 7-day forecast.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("City name (e.g. Mumbai)", text: $vm.query)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .focused($searchFieldFocused)
                .onSubmit { Task { await runSearch() } }
            if !vm.query.isEmpty {
                Button {
                    vm.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent searches")
                    .font(.headline)
                Spacer()
                Button("Clear", role: .destructive) { vm.clearRecents() }
                    .font(.subheadline)
            }

            ForEach(vm.recentCities, id: \.self) { city in
                Button {
                    Task { await runSearch(city: city) }
                } label: {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundStyle(.secondary)
                        Text(city)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Divider()
            }
        }
    }

    // MARK: - Actions

    private func runSearch(city: String? = nil) async {
        searchFieldFocused = false
        let ok: Bool
        if let city {
            ok = await vm.search(city: city)
        } else {
            ok = await vm.search()
        }
        if ok {
            path = [.current]
        }
    }
}

#Preview {
    SearchView()
}
