import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Random", systemImage: "shuffle") {
                    RandomImageView()
                }
                Tab("Gallery", systemImage: "square.grid.2x2.fill") {
                    GalleryView()
                }
            }
        }
    }
}
