import Foundation

@MainActor
final class SearchFilterViewModel: ObservableObject {
    @Published var filter = RecipeFilter()
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var availableTags: [String] = []

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
        recipes = recipeStore.recipes
        availableTags = Array(Set(recipes.flatMap { $0.tags })).sorted()
    }

    var filteredRecipes: [Recipe] {
        recipes.filter { filter.matches($0) }
    }

    func toggleFavorite(_ id: UUID) {
        favoritesStore.toggleFavorite(id)
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoritesStore.isFavorite(id)
    }

    func detailViewModel(for recipe: Recipe) -> RecipeDetailViewModel {
        RecipeDetailViewModel(recipe: recipe, favoritesStore: favoritesStore, mealPlanStore: mealPlanStore)
    }
}
