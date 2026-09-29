import SwiftUI
import SwiftData

// Screen 4: Edit Note (Update)
struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss

    // Edits the SwiftData model on Save; SwiftData autosaves the change.
    // We edit local copies so Cancel discards changes.
    let note: Note
    @State private var title: String
    @State private var content: String

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $title)
                }
                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 220)
                        .scrollContentBackground(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BackgroundView())
            .navigationTitle("Edit Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        note.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        note.content = content
                        note.updatedAt = .now
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
