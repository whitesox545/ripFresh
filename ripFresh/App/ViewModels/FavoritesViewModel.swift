import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Recipe] = []

    private let recipeStore: RecipeDataStore
    private let favoritesStore: FavoritesStore
    private let mealPlanStore: MealPlanStore

    init(recipeStore: RecipeDataStore, favoritesStore: FavoritesStore, mealPlanStore: MealPlanStore) {
        self.recipeStore = recipeStore
        self.favoritesStore = favoritesStore
        self.mealPlanStore = mealPlanStore
    }

    func load() async {
        await recipeStore.loadIfNeeded()
        favorites = recipeStore.recipes.filter { favoritesStore.favoriteIDs.contains($0.id) }
    }

    func toggleFavorite(_ id: UUID) {
        favoritesStore.toggleFavorite(id)
        favorites.removeAll { $0.id == id }
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoritesStore.isFavorite(id)
    }

    func detailViewModel(for recipe: Recipe) -> RecipeDetailViewModel {
        RecipeDetailViewModel(recipe: recipe, favoritesStore: favoritesStore, mealPlanStore: mealPlanStore)
    }
}
