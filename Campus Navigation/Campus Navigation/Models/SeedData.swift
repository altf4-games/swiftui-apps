import SwiftData

// Predefined campus libraries and book inventory, inserted on first launch.
enum SeedData {
    private typealias BookRow = (title: String, author: String, available: Int, total: Int)

    static func insertIfNeeded(into context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Library>())) ?? 0
        guard count == 0 else { return }

        let central = Library(
            name: "Central Library", block: "Main Academic Block, Ground Floor",
            latitude: 19.0732, longitude: 72.9000, openingHours: "8:00 AM – 8:00 PM",
            about: "The main campus library with reference sections, reading halls and journal archives.",
            symbol: "building.columns.fill", colorName: "indigo")
        add([
            ("The Swift Programming Language", "Apple Inc.", 5, 6),
            ("SwiftUI by Tutorials", "Kodeco Team", 3, 4),
            ("Introduction to Algorithms", "Cormen, Leiserson, Rivest, Stein", 4, 8),
            ("Computer Networks", "Andrew S. Tanenbaum", 2, 5),
            ("Data Structures Using C", "Reema Thareja", 0, 3),
            ("Clean Code", "Robert C. Martin", 1, 2),
        ], to: central, in: context)

        let engineering = Library(
            name: "Engineering Library", block: "KJSCE, B Block – 2nd Floor",
            latitude: 19.0726, longitude: 72.9012, openingHours: "9:00 AM – 6:00 PM",
            about: "Departmental collection for computer, IT, electronics and mechanical engineering.",
            symbol: "gearshape.2.fill", colorName: "orange")
        add([
            ("SwiftUI by Tutorials", "Kodeco Team", 1, 2),
            ("iOS Programming: The Big Nerd Ranch Guide", "Christian Keur, Aaron Hillegass", 2, 3),
            ("Operating System Concepts", "Silberschatz, Galvin, Gagne", 3, 6),
            ("Database System Concepts", "Silberschatz, Korth, Sudarshan", 0, 4),
            ("Digital Design", "M. Morris Mano", 4, 5),
            ("Design Patterns", "Gamma, Helm, Johnson, Vlissides", 2, 2),
        ], to: engineering, in: context)

        let science = Library(
            name: "Science Library", block: "Science Block, 1st Floor",
            latitude: 19.0741, longitude: 72.8993, openingHours: "9:00 AM – 5:30 PM",
            about: "Physics, chemistry and mathematics texts with a quiet study area.",
            symbol: "atom", colorName: "teal")
        add([
            ("Concepts of Physics", "H. C. Verma", 6, 8),
            ("Organic Chemistry", "Morrison & Boyd", 2, 4),
            ("Higher Engineering Mathematics", "B. S. Grewal", 5, 10),
            ("Introduction to Algorithms", "Cormen, Leiserson, Rivest, Stein", 0, 2),
        ], to: science, in: context)

        let digital = Library(
            name: "Digital Library", block: "IT Centre, Lab 4",
            latitude: 19.0722, longitude: 72.8985, openingHours: "Open 24 hours",
            about: "E-books, online journals and computer terminals for digital resources.",
            symbol: "desktopcomputer", colorName: "blue")
        add([
            ("SwiftUI by Tutorials", "Kodeco Team", 2, 2),
            ("Hands-On Machine Learning", "Aurélien Géron", 3, 3),
            ("Artificial Intelligence: A Modern Approach", "Stuart Russell, Peter Norvig", 1, 2),
            ("The Swift Programming Language", "Apple Inc.", 4, 4),
        ], to: digital, in: context)

        let management = Library(
            name: "Management Library", block: "SIMSR Building, 3rd Floor",
            latitude: 19.0748, longitude: 72.9008, openingHours: "9:00 AM – 7:00 PM",
            about: "Business, finance and management studies collection.",
            symbol: "chart.bar.doc.horizontal.fill", colorName: "green")
        add([
            ("Marketing Management", "Philip Kotler", 4, 6),
            ("Clean Code", "Robert C. Martin", 0, 1),
            ("Thinking, Fast and Slow", "Daniel Kahneman", 2, 3),
        ], to: management, in: context)

        try? context.save()
    }

    private static func add(_ rows: [BookRow], to library: Library, in context: ModelContext) {
        context.insert(library)
        for row in rows {
            let book = Book(title: row.title, author: row.author,
                            availableCopies: row.available, totalCopies: row.total)
            book.library = library
            context.insert(book)
        }
    }
}
