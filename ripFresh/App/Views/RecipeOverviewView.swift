import SwiftUI

struct RecipeOverviewView: View {
    @ObservedObject var viewModel: RecipeListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                header

                if viewModel.isLoading {
                    ProgressView("Lade Rezepte…")
                        .font(AppTheme.bodyFont())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                ForEach(viewModel.recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(viewModel: viewModel.detailViewModel(for: recipe))
                    } label: {
                        RecipeCardView(
                            recipe: recipe,
                            isFavorite: viewModel.isFavorite(recipe.id),
                            onFavoriteTapped: {
                                viewModel.toggleFavorite(recipe.id)
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 24)
        }
        .navigationTitle("Rezepte")
        .background(Color(.systemBackground))
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Heute frisch")
                .font(AppTheme.titleFont())
            Text("Große Bilder, klare Typografie und ruhige Farben helfen dir, schnell ein Rezept auszuwählen.")
                .font(AppTheme.bodyFont())
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
