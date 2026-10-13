import SwiftUI

struct RootView: View {
    @Environment(CallStore.self) private var store
    // Shared namespace so the call screen zooms out of the tapped avatar.
    @Namespace private var zoom

    var body: some View {
        @Bindable var store = store

        TabView {
            Tab("Contacts", systemImage: "person.crop.circle.fill") {
                ContactsView(zoom: zoom)
            }
            Tab("Recents", systemImage: "clock.fill") {
                RecentsView(zoom: zoom)
            }
            .badge(store.missedCount)
        }
        .fullScreenCover(item: $store.activeCall) { call in
            CallView(call: call)
                .navigationTransition(.zoom(sourceID: call.sourceID ?? call.id, in: zoom))
        }
    }
}
