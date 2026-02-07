import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            RecipesOverviewView(viewModel: RecipesOverviewViewModel())
                .tabItem {
                    Label("Rezepte", systemImage: "fork.knife")
                }
                .tag(RootTab.recipes)

            SearchFilterView(viewModel: SearchFilterViewModel())
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
                .tag(RootTab.search)

            FavoritesView(viewModel: FavoritesViewModel())
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
                .tag(RootTab.favorites)

            WeeklyPlanView(viewModel: WeeklyPlanViewModel())
                .tabItem {
                    Label("Plan", systemImage: "calendar")
                }
                .tag(RootTab.plan)

            ShoppingListView(viewModel: ShoppingListViewModel())
                .tabItem {
                    Label("Einkauf", systemImage: "cart")
                }
                .tag(RootTab.shopping)
        }
    }
}
