import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let imageName: String
    let durationMinutes: Int
    let servings: Int
    let difficulty: Difficulty
    let calories: Int
    let tags: [String]
    let ingredients: [Ingredient]
    let steps: [RecipeStep]

    var durationText: String {
        "\(durationMinutes) Min"
    }
}

enum Difficulty: String, Codable, CaseIterable, Hashable {
    case easy = "Leicht"
    case medium = "Mittel"
    case hard = "Anspruchsvoll"
}
