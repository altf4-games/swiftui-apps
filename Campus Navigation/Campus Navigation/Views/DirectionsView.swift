import SwiftUI
import MapKit

// Screen 5: route from the user's location to the selected library.
struct DirectionsView: View {
    @Environment(LocationManager.self) private var location
    let library: Library

    @State private var transport = Transport.walking
    @State private var route: MKRoute?
    @State private var fallbackLine: [CLLocationCoordinate2D] = []
    @State private var isLoading = false
    @State private var message: String?
    @State private var position: MapCameraPosition = .automatic

    enum Transport: String, CaseIterable {
        case walking = "figure.walk"
        case automobile = "car.fill"

        var mkType: MKDirectionsTransportType { self == .walking ? .walking : .automobile }
        var metresPerSecond: Double { self == .walking ? 1.4 : 6.0 }
    }

    private var distance: CLLocationDistance {
        route?.distance ?? location.distance(to: library.location)
    }

    private var travelTime: TimeInterval {
        route?.expectedTravelTime ?? distance / transport.metresPerSecond
    }

    private var travelTimeText: String {
        Duration.seconds(max(60, travelTime)).formatted(.units(allowed: [.hours, .minutes], width: .abbreviated))
    }

    private var routeMidpoint: CLLocationCoordinate2D? {
        if let route {
            let points = route.polyline.points()
            return points[route.polyline.pointCount / 2].coordinate
        }
        guard fallbackLine.count == 2 else { return nil }
        return CLLocationCoordinate2D(latitude: (fallbackLine[0].latitude + fallbackLine[1].latitude) / 2,
                                      longitude: (fallbackLine[0].longitude + fallbackLine[1].longitude) / 2)
    }

    var body: some View {
        VStack(spacing: 0) {
            endpoints
            Map(position: $position) {
                UserAnnotation()
                if location.location == nil {
                    Marker("Main Gate", systemImage: "door.left.hand.open", coordinate: Campus.mainGate.coordinate)
                        .tint(.blue)
                }
                Marker(library.name, systemImage: "books.vertical.fill", coordinate: library.coordinate)
                    .tint(.red)
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                } else if !fallbackLine.isEmpty {
                    MapPolyline(coordinates: fallbackLine)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [8, 8]))
                }
                if let midpoint = routeMidpoint {
                    Annotation("", coordinate: midpoint) {
                        VStack(spacing: 0) {
                            Text(travelTimeText).font(.caption.bold())
                            Text(distance.formattedDistance).font(.caption2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue, in: .rect(cornerRadius: 8))
                    }
                }
            }
            .overlay {
                if isLoading { ProgressView("Finding route…").padding().background(.regularMaterial, in: .rect(cornerRadius: 12)) }
            }
            summary
        }
        .navigationTitle("Directions")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: transport) { await calculateRoute() }
    }

    private var endpoints: some View {
        VStack(spacing: 10) {
            endpointRow(icon: "circle.circle.fill", color: .blue, text: location.referenceName)
            endpointRow(icon: "mappin.circle.fill", color: .red, text: library.name)
            Picker("Transport", selection: $transport) {
                ForEach(Transport.allCases, id: \.self) { Image(systemName: $0.rawValue) }
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }

    private func endpointRow(icon: String, color: Color, text: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(color)
            Text(text)
            Spacer()
        }
        .padding(10)
        .background(.quaternary.opacity(0.5), in: .rect(cornerRadius: 10))
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(travelTimeText) (\(distance.formattedDistance))")
                .font(.title3.bold())
            Text(message ?? "Fastest route\(route.map { $0.name.isEmpty ? "" : " via \($0.name)" } ?? "")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(action: openInMaps) {
                Label("Start", systemImage: "location.north.line.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .background(.background)
    }

    // Asks MapKit for a route; falls back to a straight line if no route is returned.
    private func calculateRoute() async {
        isLoading = true
        defer { isLoading = false }

        let start = location.referenceLocation
        let request = MKDirections.Request()
        request.source = location.location == nil
            ? MKMapItem(location: start, address: nil)
            : MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(location: library.location, address: nil)
        request.transportType = transport.mkType

        do {
            let response = try await MKDirections(request: request).calculate()
            route = response.routes.first
            fallbackLine = []
            message = location.location == nil ? "Location unavailable – route starts at the Main Gate." : nil
        } catch {
            route = nil
            fallbackLine = [start.coordinate, library.coordinate]
            message = "Route service unavailable – showing straight-line distance."
        }

        withAnimation {
            if let route {
                let rect = route.polyline.boundingMapRect
                position = .rect(rect.insetBy(dx: -rect.width * 0.3 - 100, dy: -rect.height * 0.3 - 100))
            } else {
                position = .automatic
            }
        }
    }

    private func openInMaps() {
        let destination = MKMapItem(location: library.location, address: nil)
        destination.name = library.name
        let mode = transport == .walking ? MKLaunchOptionsDirectionsModeWalking : MKLaunchOptionsDirectionsModeDriving
        destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: mode])
    }
}
