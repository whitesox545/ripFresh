import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false

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
        isLoading = recipeStore.isLoading
    }

    func toggleFavorite(_ id: UUID) {
        favoritesStore.toggleFavorite(id)
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoritesStore.isFavorite(id)
    }

    func addToPlan(_ id: UUID, day: PlanDay) {
        mealPlanStore.addRecipe(id, to: day)
    }

    func detailViewModel(for recipe: Recipe) -> RecipeDetailViewModel {
        RecipeDetailViewModel(recipe: recipe, favoritesStore: favoritesStore, mealPlanStore: mealPlanStore)
    }
}
