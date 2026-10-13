import SwiftUI

@main struct MyApp: App {
    // One shared store drives the active call and the recents log.
    @State private var store = CallStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
