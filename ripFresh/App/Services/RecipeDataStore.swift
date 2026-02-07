import Foundation

@MainActor
final class RecipeDataStore: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false

    private let cacheFilename = "recipes_cache.json"

    func loadIfNeeded() async {
        if !recipes.isEmpty || isLoading {
            return
        }
        await loadRecipes()
    }

    func reload() async {
        await loadRecipes(forceReload: true)
    }

    private func loadRecipes(forceReload: Bool = false) async {
        isLoading = true
        defer { isLoading = false }

        if !forceReload, let cached: [Recipe] = LocalPersistence.load([Recipe].self, from: cacheFilename) {
            recipes = cached
            return
        }

        guard let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            recipes = []
            return
        }

        do {
            let data = try Data(contentsOf: bundleURL)
            let decoded = try JSONDecoder().decode([Recipe].self, from: data)
            recipes = decoded
            LocalPersistence.save(decoded, to: cacheFilename)
        } catch {
            print("Failed to load recipes: \(error)")
            recipes = []
        }
    }
}
