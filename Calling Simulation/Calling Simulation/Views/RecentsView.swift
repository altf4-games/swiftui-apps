import SwiftUI

// Screen 2: Recents — the call log, with tap-to-redial.
struct RecentsView: View {
    @Environment(CallStore.self) private var store
    let zoom: Namespace.ID

    var body: some View {
        NavigationStack {
            Group {
                if store.recents.isEmpty {
                    ContentUnavailableView(
                        "No Recent Calls",
                        systemImage: "phone.badge.waveform",
                        description: Text("Calls you place or receive will show up here.")
                    )
                    .transition(.opacity)
                } else {
                    List(store.recents) { entry in
                        Button {
                            store.startCall(to: entry.contact, from: entry.id)
                        } label: {
                            RecentRow(entry: entry, zoom: zoom)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
            .navigationTitle("Recents")
            .toolbar {
                if !store.recents.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Clear", role: .destructive) { store.clearRecents() }
                    }
                }
            }
        }
    }
}

private struct RecentRow: View {
    let entry: CallLogEntry
    let zoom: Namespace.ID

    private var icon: String {
        switch (entry.direction, entry.outcome) {
        case (_, .missed): "phone.down.fill"
        case (.outgoing, _): "phone.arrow.up.right.fill"
        case (.incoming, _): "phone.arrow.down.left.fill"
        }
    }

    private var detail: String {
        switch entry.outcome {
        case .completed: entry.duration.callDuration
        case .missed: "Missed"
        case .cancelled: "Cancelled"
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(contact: entry.contact)
                .matchedTransitionSource(id: entry.id, in: zoom)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.contact.name)
                    .font(.headline)
                    .foregroundStyle(entry.outcome == .missed ? .red : .primary)
                Label(detail, systemImage: icon)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(entry.date, style: .time)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
