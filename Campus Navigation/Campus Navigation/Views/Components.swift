import SwiftUI

// Coloured tile with the library's symbol, used in rows and headers.
struct LibraryIcon: View {
    let library: Library
    var size: CGFloat = 56

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.22)
            .fill(library.tint.gradient)
            .overlay {
                Image(systemName: library.symbol)
                    .font(.system(size: size * 0.42))
                    .foregroundStyle(.white)
            }
            .frame(width: size, height: size)
    }
}

// Shown when the user's location can't be used.
struct LocationBanner: View {
    @Environment(LocationManager.self) private var location
    @Environment(\.openURL) private var openURL

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.slash.fill")
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("Location unavailable").font(.subheadline.bold())
                Text("Distances are measured from the Main Gate.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if location.isDenied {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                }
                .buttonStyle(.bordered)
            } else {
                Button("Allow") { location.requestAccess() }
                    .buttonStyle(.bordered)
            }
        }
        .padding(12)
        .background(.regularMaterial, in: .rect(cornerRadius: 16))
    }
}

struct AvailabilityText: View {
    let book: Book

    var body: some View {
        Text(book.isAvailable ? "Available (\(book.availableCopies))" : "Not Available")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(book.isAvailable ? .green : .red)
    }
}
