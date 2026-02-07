import Foundation

@MainActor
final class MealPlanViewModel: ObservableObject {
    @Published private(set) var mealPlan: MealPlan
    @Published private(set) var recipes: [Recipe] = []

    private let recipeStore: RecipeDataStore
    private let mealPlanStore: MealPlanStore
    private let favoritesStore: FavoritesStore
    private let shoppingListStore: ShoppingListStore

    init(
        recipeStore: RecipeDataStore,
        mealPlanStore: MealPlanStore,
        favoritesStore: FavoritesStore,
        shoppingListStore: ShoppingListStore
    ) {
        self.recipeStore = recipeStore
        self.mealPlanStore = mealPlanStore
        self.favoritesStore = favoritesStore
        self.shoppingListStore = shoppingListStore
        self.mealPlan = mealPlanStore.mealPlan
    }

    func load() async {
        await recipeStore.loadIfNeeded()
        recipes = recipeStore.recipes
        mealPlan = mealPlanStore.mealPlan
    }

    func recipe(for id: UUID) -> Recipe? {
        recipes.first(where: { $0.id == id })
    }

    func addRecipe(_ id: UUID, to day: PlanDay) {
        mealPlanStore.addRecipe(id, to: day)
        mealPlan = mealPlanStore.mealPlan
    }

    func removeRecipe(_ id: UUID, from day: PlanDay) {
        mealPlanStore.removeRecipe(id, from: day)
        mealPlan = mealPlanStore.mealPlan
    }

    func resetWeek() {
        mealPlanStore.replaceWeek(startingFrom: Date())
        mealPlan = mealPlanStore.mealPlan
    }

    func toggleFavorite(_ id: UUID) {
        favoritesStore.toggleFavorite(id)
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoritesStore.isFavorite(id)
    }

    func refreshShoppingList() {
        let items = mealPlan.days.flatMap { day in
            day.recipeIDs.compactMap { recipeID in
                recipe(for: recipeID)
            }
            .flatMap { recipe in
                recipe.ingredients
            }
        }

        let grouped = Dictionary(grouping: items, by: { $0.name })
        let shoppingItems = grouped.map { name, ingredients -> ShoppingItem in
            let total = ingredients.reduce(0) { $0 + $1.amount }
            let unit = ingredients.first?.unit ?? ""
            let category = ingredients.first?.category ?? "Sonstiges"
            return ShoppingItem(id: UUID(), name: name, quantity: total, unit: unit, isChecked: false, category: category)
        }
        .sorted { $0.category < $1.category }

        shoppingListStore.updateItems(shoppingItems)
    }
}
