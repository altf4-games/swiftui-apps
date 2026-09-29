import SwiftUI
import SwiftData

// Screen 3: Note Detail (Read) with entry points to Edit and Delete
struct NoteDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let note: Note

    @State private var showingEdit = false
    @State private var confirmDelete = false

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(note.title)
                        .font(.largeTitle.bold())

                    HStack(spacing: 12) {
                        Label {
                            Text(note.createdAt, format: .dateTime.day().month().year())
                        } icon: { Image(systemName: "calendar") }
                        Label {
                            Text(note.updatedAt, format: .dateTime.hour().minute())
                        } icon: { Image(systemName: "clock") }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(note.content.isEmpty ? "No content." : note.content)
                        .font(.body)
                        .foregroundStyle(note.content.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .glassEffect(.regular, in: .rect(cornerRadius: 24))
                }
                .padding()
            }
        }
        .navigationTitle("Note")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Edit", systemImage: "pencil") { showingEdit = true }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    confirmDelete = true
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditNoteView(note: note)
        }
        .confirmationDialog("Delete this note?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                dismiss()
                modelContext.delete(note)
            }
        } message: {
            Text("This cannot be undone.")
        }
    }
}
