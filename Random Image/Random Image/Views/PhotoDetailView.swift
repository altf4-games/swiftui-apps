import SwiftUI

// Screen 3: the full photo at its real aspect ratio, with details and sharing.
struct PhotoDetailView: View {
    let photo: Photo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: photo.imageURL(width: 1000, height: Int(1000 / photo.aspectRatio))) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Label("Image failed to load", systemImage: "exclamationmark.triangle")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    }
                }
                .aspectRatio(photo.aspectRatio, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 12) {
                    LabeledContent("Photographer", value: photo.author)
                    LabeledContent("Photo ID", value: "#\(photo.id)")
                    LabeledContent("Original Size", value: "\(photo.width.formatted()) × \(photo.height.formatted())")
                }
                .padding()
                .background(.background.secondary, in: .rect(cornerRadius: 16))

                if let unsplash = URL(string: photo.url) {
                    Link(destination: unsplash) {
                        Label("View on Unsplash", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
            .padding()
        }
        .navigationTitle("Photo #\(photo.id)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let download = URL(string: photo.downloadURL) {
                ShareLink(item: download)
            }
        }
    }
}
