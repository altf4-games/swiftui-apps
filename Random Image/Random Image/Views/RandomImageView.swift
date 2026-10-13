import SwiftUI

// Screen 1: one random image loaded with AsyncImage, plus effects and history.
struct RandomImageView: View {
    @State private var pool: [Photo] = []
    @State private var current: Photo?
    @State private var history: [Photo] = []
    @State private var grayscale = false
    @State private var blur = 0.0
    @State private var simulateFailure = false
    @State private var reloadToken = UUID()
    @State private var loadError: String?

    private var imageURL: URL? {
        if simulateFailure { return URL(string: "https://picsum.photos/id/invalid/800/600") }
        return current?.imageURL(width: 800, height: 600, grayscale: grayscale, blur: Int(blur))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    imageCard
                    caption
                    newImageButton
                    effects
                    if !history.isEmpty { historyStrip }
                }
                .padding()
            }
            .navigationTitle("Random Image")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if let current, let link = URL(string: current.url) {
                        Link(destination: link) {
                            Label("Open on Unsplash", systemImage: "safari")
                        }
                    }
                }
            }
            .task {
                if current == nil { await showNext() }
            }
        }
    }

    // MARK: - AsyncImage

    private var imageCard: some View {
        AsyncImage(url: imageURL, transaction: Transaction(animation: .smooth(duration: 0.4))) { phase in
            switch phase {
            case .empty:
                // Still downloading.
                ZStack {
                    Rectangle().fill(.quaternary)
                    ProgressView("Loading image…")
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            case .failure:
                ZStack {
                    Rectangle().fill(.red.opacity(0.1))
                    VStack(spacing: 12) {
                        Image(systemName: "photo.badge.exclamationmark")
                            .font(.system(size: 44))
                            .foregroundStyle(.red)
                        Text("Couldn't load image").font(.headline)
                        Button("Retry", systemImage: "arrow.clockwise") {
                            simulateFailure = false
                            reloadToken = UUID()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            @unknown default:
                EmptyView()
            }
        }
        // A new id forces AsyncImage to start a fresh download (used by Retry).
        .id(reloadToken)
        .frame(maxWidth: .infinity)
        .aspectRatio(4 / 3, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        .overlay {
            if let loadError {
                Text(loadError)
                    .font(.footnote)
                    .padding(8)
                    .background(.ultraThinMaterial, in: .capsule)
            }
        }
    }

    @ViewBuilder
    private var caption: some View {
        if let current {
            VStack(spacing: 4) {
                Text("Photo by \(current.author)")
                    .font(.headline)
                Text("#\(current.id) · \(current.width) × \(current.height)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .contentTransition(.opacity)
            .animation(.default, value: current)
        }
    }

    private var newImageButton: some View {
        Button {
            Task { await showNext() }
        } label: {
            Label("New Random Image", systemImage: "shuffle")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }

    private var effects: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Grayscale", systemImage: "circle.lefthalf.filled", isOn: $grayscale)
            VStack(alignment: .leading) {
                Label("Blur: \(Int(blur))", systemImage: "drop.fill")
                Slider(value: $blur, in: 0...10, step: 1)
            }
            // Points AsyncImage at a bad URL to show its .failure phase.
            Toggle("Simulate Broken URL", systemImage: "exclamationmark.triangle", isOn: $simulateFailure)
        }
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }

    private var historyStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recently Viewed").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(history) { photo in
                        Button {
                            withAnimation { current = photo }
                        } label: {
                            AsyncImage(url: photo.thumbnailURL(size: 160)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Rectangle().fill(.quaternary)
                            }
                            .frame(width: 72, height: 72)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                if photo == current {
                                    RoundedRectangle(cornerRadius: 12).stroke(.tint, lineWidth: 3)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Data

    // Takes the next photo from the shuffled pool, refilling it when empty.
    private func showNext() async {
        if pool.isEmpty {
            do {
                pool = try await PhotoService.randomPhotos()
                loadError = nil
            } catch {
                loadError = "Network error – check your connection."
                return
            }
        }
        let next = pool.removeFirst()
        current = next
        history.removeAll { $0 == next }
        history.insert(next, at: 0)
        history = Array(history.prefix(12))
    }
}

#Preview {
    RandomImageView()
}
