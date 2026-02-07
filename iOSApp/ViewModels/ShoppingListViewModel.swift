import Foundation
import Combine

@MainActor
public final class ShoppingListViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<[ShoppingListItem]> = .idle
    @Published public private(set) var items: [ShoppingListItem] = []

    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(loader: RecipeLoading, persistence: PersistenceStore) {
        self.loader = loader
        self.persistence = persistence
    }

    public func load() {
        state = .loading
        items = persistence.loadShoppingList()
        if items.isEmpty {
            state = .empty
        } else {
            state = .loaded(items)
        }
    }

    public func addManualItem(name: String, quantity: Double, unit: String) {
        let item = ShoppingListItem(name: name, quantity: quantity, unit: unit)
        items.append(item)
        persistence.saveShoppingList(items)
        state = .loaded(items)
    }

    public func toggleItem(_ id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isChecked.toggle()
        persistence.saveShoppingList(items)
        state = .loaded(items)
    }

    public func removeItem(_ id: UUID) {
        items.removeAll { $0.id == id }
        persistence.saveShoppingList(items)
        state = .loaded(items)
    }

    public func buildFromPlan(_ plan: WeeklyPlan) async {
        state = .loading
        var aggregatedItems: [ShoppingListItem] = []
        for plannedRecipes in plan.days.values {
            for planned in plannedRecipes {
                guard let recipe = try? await loader.loadRecipe(id: planned.recipeId) else { continue }
                let multiplier = max(Double(planned.servings) / Double(recipe.servings), 1.0)
                let recipeItems = recipe.ingredients.map {
                    ShoppingListItem(
                        name: $0.name,
                        quantity: $0.quantity * multiplier,
                        unit: $0.unit,
                        sourceRecipeId: recipe.id
                    )
                }
                aggregatedItems.append(contentsOf: recipeItems)
            }
        }
        items = mergeItems(aggregatedItems)
        persistence.saveShoppingList(items)
        state = items.isEmpty ? .empty : .loaded(items)
    }

    private func mergeItems(_ items: [ShoppingListItem]) -> [ShoppingListItem] {
        var merged: [String: ShoppingListItem] = [:]
        for item in items {
            let key = "\(item.name.lowercased())|\(item.unit.lowercased())"
            if var existing = merged[key] {
                existing.quantity += item.quantity
                merged[key] = existing
            } else {
                merged[key] = item
            }
        }
        return merged.values.sorted { $0.name < $1.name }
    }
}
