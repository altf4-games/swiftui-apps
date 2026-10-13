import SwiftUI
import SwiftData
import MapKit

// Screen 1: campus map with markers for libraries and other facilities.
struct CampusMapView: View {
    @Environment(LocationManager.self) private var location
    @Query(sort: \Library.name) private var libraries: [Library]

    @State private var position: MapCameraPosition = .region(Campus.region)
    @State private var category: FacilityCategory?
    @State private var selection: String?
    @State private var searchText = ""

    private var visibleLibraries: [Library] {
        guard category == nil || category == .library else { return [] }
        return libraries.filter { matches($0.name) }
    }

    private var visibleFacilities: [Facility] {
        Facility.all.filter { (category == nil || $0.category == category) && matches($0.name) }
    }

    private var selectedLibrary: Library? {
        libraries.first { $0.name == selection }
    }

    private var selectedFacility: Facility? {
        Facility.all.first { $0.name == selection }
    }

    var body: some View {
        NavigationStack {
            Map(position: $position, selection: $selection) {
                UserAnnotation()

                ForEach(visibleLibraries) { library in
                    Annotation(library.name, coordinate: library.coordinate) {
                        Image(systemName: "books.vertical.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(.red.gradient, in: .circle)
                            .overlay(Circle().stroke(.white, lineWidth: 2))
                            .scaleEffect(selection == library.name ? 1.25 : 1)
                            .animation(.spring, value: selection)
                    }
                    .tag(library.name)
                }

                ForEach(visibleFacilities) { facility in
                    Marker(facility.name, systemImage: facility.category.symbol, coordinate: facility.coordinate)
                        .tint(facility.category.color)
                        .tag(facility.name)
                }
            }
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .safeAreaInset(edge: .top) { categoryChips }
            .safeAreaInset(edge: .bottom) { bottomCard }
            .navigationTitle("Campus Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search places")
            .onSubmit(of: .search) { focusOnFirstMatch() }
            .navigationDestination(for: Library.self) { LibraryDetailView(library: $0) }
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("All", isSelected: category == nil) { category = nil }
                ForEach(FacilityCategory.allCases) { item in
                    chip(item.rawValue, isSelected: category == item) { category = item }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private func chip(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation { action() }
        } label: {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .foregroundStyle(isSelected ? .white : .primary)
                .background(isSelected ? AnyShapeStyle(.blue) : AnyShapeStyle(.regularMaterial), in: .capsule)
        }
    }

    @ViewBuilder
    private var bottomCard: some View {
        VStack(spacing: 10) {
            if location.location == nil {
                LocationBanner()
            }
            if let library = selectedLibrary {
                libraryCard(library)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if let facility = selectedFacility {
                facilityCard(facility)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding()
        .animation(.spring, value: selection)
    }

    private func libraryCard(_ library: Library) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                LibraryIcon(library: library, size: 48)
                VStack(alignment: .leading, spacing: 2) {
                    Text(library.name).font(.headline)
                    Text("\(location.distance(to: library.location).formattedDistance) · \(library.availableBooks) books available")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            HStack {
                NavigationLink {
                    DirectionsView(library: library)
                } label: {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                NavigationLink(value: library) {
                    Text("Details").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 20))
    }

    private func facilityCard(_ facility: Facility) -> some View {
        HStack(spacing: 12) {
            Image(systemName: facility.category.symbol)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(facility.category.color.gradient, in: .circle)
            VStack(alignment: .leading, spacing: 2) {
                Text(facility.name).font(.headline)
                Text("\(facility.category.rawValue) · \(location.distance(to: facility.location).formattedDistance) away")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: .rect(cornerRadius: 20))
    }

    private func matches(_ name: String) -> Bool {
        searchText.isEmpty || name.localizedCaseInsensitiveContains(searchText)
    }

    // Moves the camera to the first place matching the search text.
    private func focusOnFirstMatch() {
        let coordinate = visibleLibraries.first?.coordinate ?? visibleFacilities.first?.coordinate
        guard let coordinate else { return }
        selection = visibleLibraries.first?.name ?? visibleFacilities.first?.name
        withAnimation {
            position = .camera(MapCamera(centerCoordinate: coordinate, distance: 700))
        }
    }
}
