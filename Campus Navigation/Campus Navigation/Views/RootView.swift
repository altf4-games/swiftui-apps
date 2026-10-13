import SwiftUI

struct RootView: View {
    @Environment(LocationManager.self) private var location

    var body: some View {
        TabView {
            Tab("Map", systemImage: "map.fill") {
                CampusMapView()
            }
            Tab("Libraries", systemImage: "books.vertical.fill") {
                LibraryListView()
            }
            Tab("Search", systemImage: "text.book.closed.fill") {
                BookSearchView()
            }
        }
        .task { location.requestAccess() }
    }
}
