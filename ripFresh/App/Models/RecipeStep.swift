import Foundation

struct RecipeStep: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let instructions: String
    let durationMinutes: Int
}
