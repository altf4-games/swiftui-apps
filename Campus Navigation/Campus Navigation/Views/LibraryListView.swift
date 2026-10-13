import SwiftUI
import SwiftData

// Screen 2: libraries sorted by distance from the user.
struct LibraryListView: View {
    @Environment(LocationManager.self) private var location
    @Query private var libraries: [Library]
    @State private var searchText = ""

    private var sortedLibraries: [Library] {
        libraries
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
            .sorted { location.distance(to: $0.location) < location.distance(to: $1.location) }
    }

    var body: some View {
        NavigationStack {
            List {
                if location.location == nil {
                    LocationBanner()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                Section("Nearby Libraries (sorted by distance)") {
                    ForEach(sortedLibraries) { library in
                        NavigationLink(value: library) {
                            LibraryRow(library: library,
                                       distance: location.distance(to: library.location))
                        }
                    }
                }
            }
            .overlay {
                if sortedLibraries.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .navigationTitle("Libraries")
            .searchable(text: $searchText, prompt: "Search libraries")
            .navigationDestination(for: Library.self) { LibraryDetailView(library: $0) }
        }
    }
}

struct LibraryRow: View {
    let library: Library
    let distance: Double

    var body: some View {
        HStack(spacing: 14) {
            LibraryIcon(library: library)
            VStack(alignment: .leading, spacing: 4) {
                Text(library.name).font(.headline)
                Label(distance.formattedDistance, systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                Text("\(library.availableBooks) / \(library.totalBooks) books available")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
