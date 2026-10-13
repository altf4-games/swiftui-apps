import SwiftUI
import SwiftData
import CoreLocation

@Model final class Library {
    var name: String
    var block: String
    var latitude: Double
    var longitude: Double
    var openingHours: String
    var about: String
    var symbol: String
    var colorName: String
    @Relationship(deleteRule: .cascade, inverse: \Book.library) var books: [Book] = []

    init(name: String, block: String, latitude: Double, longitude: Double,
         openingHours: String, about: String, symbol: String, colorName: String) {
        self.name = name
        self.block = block
        self.latitude = latitude
        self.longitude = longitude
        self.openingHours = openingHours
        self.about = about
        self.symbol = symbol
        self.colorName = colorName
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    var availableBooks: Int { books.reduce(0) { $0 + $1.availableCopies } }
    var totalBooks: Int { books.reduce(0) { $0 + $1.totalCopies } }

    var tint: Color {
        switch colorName {
        case "orange": .orange
        case "teal": .teal
        case "blue": .blue
        case "green": .green
        default: .indigo
        }
    }
}

@Model final class Book {
    var title: String
    var author: String
    var availableCopies: Int
    var totalCopies: Int
    var library: Library?

    init(title: String, author: String, availableCopies: Int, totalCopies: Int) {
        self.title = title
        self.author = author
        self.availableCopies = availableCopies
        self.totalCopies = totalCopies
    }

    var isAvailable: Bool { availableCopies > 0 }
}
