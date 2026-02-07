import Foundation
import Combine

@MainActor
public final class RecipeOverviewViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<[Recipe]> = .idle
    @Published public private(set) var favorites: Set<UUID> = []
    @Published public var filter: SearchFilter

    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(loader: RecipeLoading, persistence: PersistenceStore) {
        self.loader = loader
        self.persistence = persistence
        self.filter = persistence.loadSearchFilter()
        self.favorites = persistence.loadFavorites()
    }

    public func load() async {
        state = .loading
        do {
            let recipes = try await loader.searchRecipes(filter: filter)
            if recipes.isEmpty {
                state = .empty
            } else {
                state = .loaded(recipes)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    public func updateFilter(_ newFilter: SearchFilter) async {
        filter = newFilter
        persistence.saveSearchFilter(newFilter)
        await load()
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
