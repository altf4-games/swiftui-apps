import Foundation

// One photo from the Picsum Photos API (https://picsum.photos).
struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String           // Unsplash page
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }

    var aspectRatio: CGFloat {
        CGFloat(width) / CGFloat(height)
    }

    // Builds a resized image URL, optionally greyscale and/or blurred.
    func imageURL(width: Int, height: Int, grayscale: Bool = false, blur: Int = 0) -> URL? {
        var components = URLComponents(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")
        var query: [URLQueryItem] = []
        if grayscale { query.append(URLQueryItem(name: "grayscale", value: nil)) }
        if blur > 0 { query.append(URLQueryItem(name: "blur", value: String(blur))) }
        components?.queryItems = query.isEmpty ? nil : query
        return components?.url
    }

    func thumbnailURL(size: Int = 300) -> URL? {
        imageURL(width: size, height: size)
    }
}
