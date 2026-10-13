import SwiftUI

// Screen 1: Contacts — tap a contact to place a call.
struct ContactsView: View {
    @Environment(CallStore.self) private var store
    let zoom: Namespace.ID

    var body: some View {
        NavigationStack {
            List(Contact.samples) { contact in
                Button {
                    store.startCall(to: contact, from: contact.id)
                } label: {
                    HStack(spacing: 14) {
                        AvatarView(contact: contact)
                            .matchedTransitionSource(id: contact.id, in: zoom)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(contact.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(contact.phone)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "phone.fill")
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(.green, in: .circle)
                    }
                    .padding(.vertical, 4)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Simulate Incoming Call", systemImage: "phone.arrow.down.left.fill") {
                        store.simulateIncomingCall()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var zoom
    ContactsView(zoom: zoom)
        .environment(CallStore())
}
