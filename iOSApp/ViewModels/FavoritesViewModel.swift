import Foundation
import Combine

@MainActor
public final class FavoritesViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<[Recipe]> = .idle
    @Published public private(set) var favorites: Set<UUID> = []

    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(loader: RecipeLoading, persistence: PersistenceStore) {
        self.loader = loader
        self.persistence = persistence
        self.favorites = persistence.loadFavorites()
    }

    public func load() async {
        state = .loading
        do {
            let allRecipes = try await loader.loadRecipes()
            let favoriteRecipes = allRecipes.filter { favorites.contains($0.id) }
            if favoriteRecipes.isEmpty {
                state = .empty
            } else {
                state = .loaded(favoriteRecipes)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    public func toggleFavorite(recipeId: UUID) {
        if favorites.contains(recipeId) {
            favorites.remove(recipeId)
        } else {
            favorites.insert(recipeId)
        }
        persistence.saveFavorites(favorites)
    }
}
