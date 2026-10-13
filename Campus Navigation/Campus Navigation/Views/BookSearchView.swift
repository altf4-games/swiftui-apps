import SwiftUI
import SwiftData

// Screen 4: search for a book and see which libraries have it.
struct BookSearchView: View {
    @Environment(LocationManager.self) private var location
    @Query private var books: [Book]
    @State private var searchText = ""

    private let suggestions = ["SwiftUI", "Algorithms", "Clean Code", "Physics", "Machine Learning"]

    private var results: [Book] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return [] }
        return books
            .filter { $0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query) }
            .sorted { distance(of: $0) < distance(of: $1) }
    }

    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section("Try searching for") {
                        ForEach(suggestions, id: \.self) { term in
                            Button {
                                searchText = term
                            } label: {
                                Label(term, systemImage: "magnifyingglass")
                            }
                        }
                    }
                } else {
                    ForEach(results) { book in
                        if let library = book.library {
                            NavigationLink(value: library) {
                                BookResultRow(book: book, library: library, distance: distance(of: book))
                            }
                        }
                    }
                }
            }
            .overlay {
                if !searchText.isEmpty && results.isEmpty {
                    ContentUnavailableView {
                        Label("Book Not Found", systemImage: "book.closed")
                    } description: {
                        Text("No campus library has a book matching \"\(searchText)\".")
                    }
                }
            }
            .navigationTitle("Search Books")
            .searchable(text: $searchText, prompt: "Book title or author")
            .navigationDestination(for: Library.self) { LibraryDetailView(library: $0) }
        }
    }

    private func distance(of book: Book) -> Double {
        guard let library = book.library else { return .infinity }
        return location.distance(to: library.location)
    }
}

private struct BookResultRow: View {
    let book: Book
    let library: Library
    let distance: Double

    var body: some View {
        HStack(spacing: 14) {
            LibraryIcon(library: library, size: 50)
            VStack(alignment: .leading, spacing: 3) {
                Text(library.name).font(.headline)
                Text(book.title).font(.subheadline).foregroundStyle(.blue).lineLimit(1)
                AvailabilityText(book: book)
            }
            Spacer()
            Text(distance.formattedDistance)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
