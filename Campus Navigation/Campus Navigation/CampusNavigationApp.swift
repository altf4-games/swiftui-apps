import SwiftUI
import SwiftData

@main struct CampusNavigationApp: App {
    let container: ModelContainer
    @State private var location = LocationManager()

    init() {
        do {
            container = try ModelContainer(for: Library.self, Book.self)
            SeedData.insertIfNeeded(into: container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(location)
        }
        .modelContainer(container)
    }
}
