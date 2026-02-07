import Foundation

public protocol RecipeLoading {
    func loadRecipes() async throws -> [Recipe]
    func loadRecipe(id: UUID) async throws -> Recipe?
    func searchRecipes(filter: SearchFilter) async throws -> [Recipe]
}

public final class InMemoryRecipeLoader: RecipeLoading {
    private let recipes: [Recipe]

    public init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    public func loadRecipes() async throws -> [Recipe] {
        recipes
    }

    public func loadRecipe(id: UUID) async throws -> Recipe? {
        recipes.first { $0.id == id }
    }

    public func searchRecipes(filter: SearchFilter) async throws -> [Recipe] {
        recipes.filter { recipe in
            let matchesQuery = filter.query.isEmpty || recipe.title.localizedCaseInsensitiveContains(filter.query)
            let matchesTags = filter.tags.isEmpty || !filter.tags.isDisjoint(with: Set(recipe.tags))
            let matchesDuration = filter.maxDurationMinutes.map { recipe.durationMinutes <= $0 } ?? true
            return matchesQuery && matchesTags && matchesDuration
        }
    }
}
