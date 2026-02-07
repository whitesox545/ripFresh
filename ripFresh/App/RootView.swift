import SwiftUI

struct RootView: View {
    @ObservedObject var recipeStore: RecipeDataStore
    @ObservedObject var favoritesStore: FavoritesStore
    @ObservedObject var mealPlanStore: MealPlanStore
    @ObservedObject var shoppingListStore: ShoppingListStore

    var body: some View {
        TabView {
            NavigationStack {
                RecipeOverviewView(
                    viewModel: RecipeListViewModel(
                        recipeStore: recipeStore,
                        favoritesStore: favoritesStore,
                        mealPlanStore: mealPlanStore
                    )
                )
            }
            .tabItem {
                Label("Rezepte", systemImage: "book")
            }

            NavigationStack {
                SearchFilterView(
                    viewModel: SearchFilterViewModel(
                        recipeStore: recipeStore,
                        favoritesStore: favoritesStore,
                        mealPlanStore: mealPlanStore
                    )
                )
            }
            .tabItem {
                Label("Suche", systemImage: "magnifyingglass")
            }

            NavigationStack {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        recipeStore: recipeStore,
                        favoritesStore: favoritesStore,
                        mealPlanStore: mealPlanStore
                    )
                )
            }
            .tabItem {
                Label("Favoriten", systemImage: "heart")
            }

            NavigationStack {
                MealPlanView(
                    viewModel: MealPlanViewModel(
                        recipeStore: recipeStore,
                        mealPlanStore: mealPlanStore,
                        favoritesStore: favoritesStore,
                        shoppingListStore: shoppingListStore
                    )
                )
            }
            .tabItem {
                Label("Wochenplan", systemImage: "calendar")
            }

            NavigationStack {
                ShoppingListView(
                    viewModel: ShoppingListViewModel(
                        recipeStore: recipeStore,
                        shoppingListStore: shoppingListStore,
                        mealPlanStore: mealPlanStore
                    )
                )
            }
            .tabItem {
                Label("Einkauf", systemImage: "cart")
            }
        }
    }
}
