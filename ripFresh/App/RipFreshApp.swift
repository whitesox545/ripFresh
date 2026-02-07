import SwiftUI

@main
struct RipFreshApp: App {
    @StateObject private var recipeStore = RecipeDataStore()
    @StateObject private var favoritesStore = FavoritesStore()
    @StateObject private var mealPlanStore = MealPlanStore()
    @StateObject private var shoppingListStore = ShoppingListStore()

    var body: some Scene {
        WindowGroup {
            RootView(
                recipeStore: recipeStore,
                favoritesStore: favoritesStore,
                mealPlanStore: mealPlanStore,
                shoppingListStore: shoppingListStore
            )
        }
    }
}
