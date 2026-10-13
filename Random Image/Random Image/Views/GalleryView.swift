import SwiftUI

// Screen 2: a grid of random thumbnails, each loaded with its own AsyncImage.
struct GalleryView: View {
    @State private var photos: [Photo] = []
    @State private var errorMessage: String?

    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 8)]

    var body: some View {
        NavigationStack {
            Group {
                if let errorMessage, photos.isEmpty {
                    ContentUnavailableView {
                        Label("Couldn't Load Photos", systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Try Again") { Task { await load() } }
                    }
                } else if photos.isEmpty {
                    ProgressView("Fetching photos…")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(photos) { photo in
                                NavigationLink(value: photo) {
                                    Thumbnail(photo: photo)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Gallery")
            .navigationDestination(for: Photo.self) { PhotoDetailView(photo: $0) }
            .refreshable { await load() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Shuffle", systemImage: "arrow.triangle.2.circlepath") {
                        Task { await load() }
                    }
                }
            }
            .task {
                if photos.isEmpty { await load() }
            }
        }
    }

    private func load() async {
        do {
            let fresh = try await PhotoService.randomPhotos()
            withAnimation { photos = fresh }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct Thumbnail: View {
    let photo: Photo

    var body: some View {
        // Square cell; the image fills it and is clipped.
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                AsyncImage(url: photo.thumbnailURL(), transaction: Transaction(animation: .easeIn)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill().transition(.opacity)
                    case .failure:
                        Image(systemName: "photo").foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
            }
            .background(.quaternary)
            .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    GalleryView()
}
