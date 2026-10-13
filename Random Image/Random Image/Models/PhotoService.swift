import Foundation

enum PhotoService {
    // Picsum has roughly 1,000 photos; 30 pages of 30 covers them.
    private static let pageCount = 30
    private static let pageSize = 30

    // Fetches one random page of photo metadata and shuffles it.
    static func randomPhotos() async throws -> [Photo] {
        let page = Int.random(in: 1...pageCount)
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(pageSize)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Photo].self, from: data).shuffled()
    }
}
