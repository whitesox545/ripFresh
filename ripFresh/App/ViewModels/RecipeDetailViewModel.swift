import Foundation

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    @Published private(set) var recipe: Recipe

    private let favoritesStore: FavoritesStore
    private let mealPlanStore: MealPlanStore

    init(recipe: Recipe, favoritesStore: FavoritesStore, mealPlanStore: MealPlanStore) {
        self.recipe = recipe
        self.favoritesStore = favoritesStore
        self.mealPlanStore = mealPlanStore
    }

    func toggleFavorite() {
        favoritesStore.toggleFavorite(recipe.id)
    }

    func isFavorite() -> Bool {
        favoritesStore.isFavorite(recipe.id)
    }

    func addToPlan(day: PlanDay) {
        mealPlanStore.addRecipe(recipe.id, to: day)
    }

    var planDays: [PlanDay] {
        mealPlanStore.mealPlan.days
    }
}
