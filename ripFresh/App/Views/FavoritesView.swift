import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        VStack {
            if viewModel.favorites.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.favorites) { recipe in
                        NavigationLink {
                            RecipeDetailView(viewModel: viewModel.detailViewModel(for: recipe))
                        } label: {
                            RecipeRowView(
                                recipe: recipe,
                                isFavorite: viewModel.isFavorite(recipe.id),
                                onFavoriteTapped: { viewModel.toggleFavorite(recipe.id) }
                            )
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favoriten")
        .task {
            await viewModel.load()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.secondaryText)
            Text("Noch keine Favoriten")
                .font(AppTheme.subtitleFont())
            Text("Speichere Rezepte, die du gern kochst, für schnellen Zugriff offline.")
                .font(AppTheme.bodyFont())
                .foregroundColor(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}
