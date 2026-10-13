import SwiftUI
import MapKit

// Fixed campus layout. Coordinates approximate the Somaiya Vidyavihar campus.
enum Campus {
    static let center = CLLocationCoordinate2D(latitude: 19.0731, longitude: 72.8999)
    static let mainGate = CLLocation(latitude: 19.0744, longitude: 72.9013)
    static let region = MKCoordinateRegion(
        center: center,
        span: MKCoordinateSpan(latitudeDelta: 0.0055, longitudeDelta: 0.0055)
    )
}

enum FacilityCategory: String, CaseIterable, Identifiable {
    case library = "Libraries"
    case classroom = "Classrooms"
    case cafeteria = "Cafeteria"
    case sports = "Sports"
    case parking = "Parking"
    case medical = "Medical"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .library: "books.vertical.fill"
        case .classroom: "graduationcap.fill"
        case .cafeteria: "fork.knife"
        case .sports: "figure.run"
        case .parking: "parkingsign"
        case .medical: "cross.case.fill"
        }
    }

    var color: Color {
        switch self {
        case .library: .red
        case .classroom: .purple
        case .cafeteria: .orange
        case .sports: .green
        case .parking: .blue
        case .medical: .pink
        }
    }
}

// Non-library places shown on the campus map.
struct Facility: Identifiable {
    let name: String
    let category: FacilityCategory
    let latitude: Double
    let longitude: Double

    var id: String { name }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }

    static let all: [Facility] = [
        Facility(name: "A Block Classrooms", category: .classroom, latitude: 19.0724, longitude: 72.9004),
        Facility(name: "C Block Classrooms", category: .classroom, latitude: 19.0738, longitude: 72.9019),
        Facility(name: "Main Canteen", category: .cafeteria, latitude: 19.0729, longitude: 72.8990),
        Facility(name: "Food Court", category: .cafeteria, latitude: 19.0745, longitude: 72.9000),
        Facility(name: "Sports Ground", category: .sports, latitude: 19.0753, longitude: 72.8988),
        Facility(name: "Gate Parking", category: .parking, latitude: 19.0712, longitude: 72.9006),
        Facility(name: "Health Centre", category: .medical, latitude: 19.0719, longitude: 72.9016),
    ]
}
