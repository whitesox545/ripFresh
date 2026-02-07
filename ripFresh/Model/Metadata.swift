import Foundation

struct Metadata: Codable, Hashable, Sendable {
    let source: String?
    let author: String?
    let cuisine: String?
    let tags: [String]
    let allergens: [String]
    let createdAt: Date?
    let updatedAt: Date?

    init(
        source: String?,
        author: String?,
        cuisine: String?,
        tags: [String],
        allergens: [String],
        createdAt: Date?,
        updatedAt: Date?
    ) {
        self.source = source
        self.author = author
        self.cuisine = cuisine
        self.tags = tags
        self.allergens = allergens
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
