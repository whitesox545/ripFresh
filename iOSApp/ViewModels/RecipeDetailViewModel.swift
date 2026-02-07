import Foundation
import Combine

@MainActor
public final class RecipeDetailViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<Recipe> = .idle
    @Published public private(set) var isFavorite: Bool = false

    private let recipeId: UUID
    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(recipeId: UUID, loader: RecipeLoading, persistence: PersistenceStore) {
        self.recipeId = recipeId
        self.loader = loader
        self.persistence = persistence
        self.isFavorite = persistence.loadFavorites().contains(recipeId)
    }

    public func load() async {
        state = .loading
        do {
            if let recipe = try await loader.loadRecipe(id: recipeId) {
                state = .loaded(recipe)
            } else {
                state = .empty
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    public func toggleFavorite() {
        var favorites = persistence.loadFavorites()
        if favorites.contains(recipeId) {
            favorites.remove(recipeId)
            isFavorite = false
        } else {
            favorites.insert(recipeId)
            isFavorite = true
        }
        persistence.saveFavorites(favorites)
    }
}
