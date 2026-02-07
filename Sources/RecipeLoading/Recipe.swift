import Foundation

public struct Recipe: Codable, Equatable, Identifiable {
    public let id: UUID
    public let title: String
    public let summary: String?
    public let servings: Int?
    public let prepTimeMinutes: Int?
    public let cookTimeMinutes: Int?
    public let ingredients: [String]
    public let steps: [String]
    public let imageName: String?

    public init(
        id: UUID,
        title: String,
        summary: String? = nil,
        servings: Int? = nil,
        prepTimeMinutes: Int? = nil,
        cookTimeMinutes: Int? = nil,
        ingredients: [String],
        steps: [String],
        imageName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.servings = servings
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.ingredients = ingredients
        self.steps = steps
        self.imageName = imageName
    }
}
