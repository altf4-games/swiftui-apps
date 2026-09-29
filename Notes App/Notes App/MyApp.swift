import SwiftUI
import SwiftData

@main struct MyApp: App {
    // ModelContainer: sets up the persistent SwiftData store for Note.
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Note.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            NotesView()
        }
        // Injects the container and its ModelContext into the environment.
        .modelContainer(container)
    }
}
