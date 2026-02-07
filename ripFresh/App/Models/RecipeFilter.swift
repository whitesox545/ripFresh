import Foundation

struct RecipeFilter: Hashable {
    var query: String = ""
    var maxTime: Int? = nil
    var difficulty: Difficulty? = nil
    var selectedTags: Set<String> = []

    func matches(_ recipe: Recipe) -> Bool {
        if !query.isEmpty {
            let normalized = query.lowercased()
            let matchesTitle = recipe.title.lowercased().contains(normalized)
            let matchesTags = recipe.tags.contains { $0.lowercased().contains(normalized) }
            if !matchesTitle && !matchesTags {
                return false
            }
        }
        if let maxTime, recipe.durationMinutes > maxTime {
            return false
        }
        if let difficulty, recipe.difficulty != difficulty {
            return false
        }
        if !selectedTags.isEmpty {
            let recipeTags = Set(recipe.tags)
            if recipeTags.isDisjoint(with: selectedTags) {
                return false
            }
        }
        return true
    }
}
