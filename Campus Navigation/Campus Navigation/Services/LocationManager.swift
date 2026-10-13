import CoreLocation
import Observation

// Wraps CLLocationManager and publishes the user's location and permission state.
@Observable final class LocationManager: NSObject, CLLocationManagerDelegate {
    var location: CLLocation?
    var authorization: CLAuthorizationStatus

    @ObservationIgnored private let manager = CLLocationManager()

    override init() {
        authorization = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    var isDenied: Bool {
        authorization == .denied || authorization == .restricted
    }

    // Distances fall back to the main gate when location is unavailable.
    var referenceLocation: CLLocation {
        location ?? Campus.mainGate
    }

    var referenceName: String {
        location == nil ? "Main Gate" : "My Location"
    }

    func requestAccess() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
        }
    }

    func distance(to place: CLLocation) -> CLLocationDistance {
        referenceLocation.distance(from: place)
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
        Task { @MainActor in self.authorization = status }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        Task { @MainActor in self.location = latest }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Keep the last known location; the UI falls back to the main gate if there is none.
    }
}

extension CLLocationDistance {
    // 320 -> "320 m", 1250 -> "1.3 km"
    var formattedDistance: String {
        self < 1000 ? "\(Int(self.rounded())) m" : String(format: "%.1f km", self / 1000)
    }
}
