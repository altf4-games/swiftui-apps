import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.createdAt = .now
        self.updatedAt = .now
    }
}
