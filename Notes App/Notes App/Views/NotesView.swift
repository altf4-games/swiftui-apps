import SwiftUI
import SwiftData

// Screen 1: Notes list (Read + Delete)
struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    // @Query fetches notes from SwiftData and keeps the UI in sync.
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    @State private var showingAdd = false
    @State private var searchText = ""

    private var filtered: [Note] {
        guard !searchText.isEmpty else { return notes }
        return notes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()

                if notes.isEmpty {
                    ContentUnavailableView(
                        "No Notes Yet",
                        systemImage: "note.text",
                        description: Text("Tap + to create your first note.")
                    )
                } else {
                    List {
                        ForEach(filtered) { note in
                            NavigationLink(value: note) {
                                NoteRow(note: note)
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.clear)
                                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
                                    .padding(.vertical, 4)
                            )
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Notes")
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(note: note)
            }
            .searchable(text: $searchText, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Note", systemImage: "plus") { showingAdd = true }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddNoteView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filtered[index])
        }
    }
}

struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title.isEmpty ? "Untitled" : note.title)
                .font(.headline)
                .lineLimit(1)
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(note.updatedAt, format: .dateTime.day().month().year().hour().minute())
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
    }
}

struct BackgroundView: View {
    var body: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.5, 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                .indigo, .purple, .blue,
                .blue, .pink, .purple,
                .teal, .indigo, .blue
            ]
        )
        .opacity(0.35)
        .ignoresSafeArea()
    }
}

#Preview {
    NotesView()
        .modelContainer(for: Note.self, inMemory: true)
}
