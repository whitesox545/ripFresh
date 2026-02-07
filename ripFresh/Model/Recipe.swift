import Foundation

struct Recipe: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let title: String
    let summary: String?
    let servings: Int
    let preparationTimeMinutes: Int?
    let cookingTimeMinutes: Int?
    let ingredients: [Ingredient]
    let steps: [Step]
    let nutrition: Nutrition?
    let metadata: Metadata

    init(
        id: String,
        title: String,
        summary: String?,
        servings: Int,
        preparationTimeMinutes: Int?,
        cookingTimeMinutes: Int?,
        ingredients: [Ingredient],
        steps: [Step],
        nutrition: Nutrition?,
        metadata: Metadata
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.servings = servings
        self.preparationTimeMinutes = preparationTimeMinutes
        self.cookingTimeMinutes = cookingTimeMinutes
        self.ingredients = ingredients
        self.steps = steps
        self.nutrition = nutrition
        self.metadata = metadata
    }
}
