import SwiftUI
import MapKit

// Screen 3: library information, book availability and directions.
struct LibraryDetailView: View {
    @Environment(LocationManager.self) private var location
    let library: Library

    @State private var tab = DetailTab.books
    @State private var bookQuery = ""
    @State private var showingMap = false

    enum DetailTab: String, CaseIterable {
        case books = "Book Availability"
        case about = "About"
    }

    private var filteredBooks: [Book] {
        library.books
            .filter { bookQuery.isEmpty || $0.title.localizedCaseInsensitiveContains(bookQuery) }
            .sorted { $0.title < $1.title }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                actions
                Picker("Section", selection: $tab) {
                    ForEach(DetailTab.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)

                switch tab {
                case .books: booksSection
                case .about: aboutSection
                }
            }
            .padding()
        }
        .navigationTitle("Library Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingMap) {
            LibraryMapSheet(library: library)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 20)
                .fill(library.tint.gradient)
                .frame(height: 150)
                .overlay {
                    Image(systemName: library.symbol)
                        .font(.system(size: 64))
                        .foregroundStyle(.white.opacity(0.9))
                }
            HStack {
                Text(library.name).font(.title2.bold())
                Spacer()
                Label(location.distance(to: library.location).formattedDistance, systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
            Label(library.block, systemImage: "mappin.and.ellipse")
                .foregroundStyle(.secondary)
            Label(library.openingHours, systemImage: "clock")
                .foregroundStyle(.secondary)
        }
    }

    private var actions: some View {
        HStack {
            NavigationLink {
                DirectionsView(library: library)
            } label: {
                Text("Get Directions").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                showingMap = true
            } label: {
                Text("View on Map").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .controlSize(.large)
    }

    private var booksSection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search books in this library", text: $bookQuery)
            }
            .padding(10)
            .background(.quaternary.opacity(0.5), in: .rect(cornerRadius: 10))
            .padding(.bottom, 8)

            if filteredBooks.isEmpty {
                ContentUnavailableView("Book Not Found", systemImage: "book.closed",
                                       description: Text("This library has no book matching \"\(bookQuery)\"."))
            }
            ForEach(filteredBooks) { book in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title).font(.subheadline.weight(.medium))
                        Text(book.author).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    AvailabilityText(book: book)
                }
                .padding(.vertical, 10)
                Divider()
            }
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(library.about)
            LabeledContent("Titles in catalogue", value: "\(library.books.count)")
            LabeledContent("Copies available", value: "\(library.availableBooks) of \(library.totalBooks)")
            LabeledContent("Opening hours", value: library.openingHours)
        }
    }
}

// "View on Map": a map focused on this library using MapCameraPosition.
struct LibraryMapSheet: View {
    let library: Library
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                UserAnnotation()
                Marker(library.name, systemImage: "books.vertical.fill", coordinate: library.coordinate)
                    .tint(.red)
            }
            .onAppear {
                position = .camera(MapCamera(centerCoordinate: library.coordinate, distance: 500, pitch: 45))
            }
            .navigationTitle(library.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
