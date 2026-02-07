import Foundation

@MainActor
final class ShoppingListViewModel: ObservableObject {
    @Published private(set) var items: [ShoppingItem] = []
    @Published var manualEntry = ""

    private let recipeStore: RecipeDataStore
    private let shoppingListStore: ShoppingListStore
    private let mealPlanStore: MealPlanStore

    init(recipeStore: RecipeDataStore, shoppingListStore: ShoppingListStore, mealPlanStore: MealPlanStore) {
        self.recipeStore = recipeStore
        self.shoppingListStore = shoppingListStore
        self.mealPlanStore = mealPlanStore
    }

    func load() async {
        await recipeStore.loadIfNeeded()
        items = shoppingListStore.items
    }

    func toggle(_ item: ShoppingItem) {
        shoppingListStore.toggleItem(item)
        items = shoppingListStore.items
    }

    func addManual() {
        let trimmed = manualEntry.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        shoppingListStore.addManualItem(name: trimmed)
        manualEntry = ""
        items = shoppingListStore.items
    }

    func refreshFromPlan(recipes: [Recipe]) {
        let items = mealPlanStore.mealPlan.days.flatMap { day in
            day.recipeIDs.compactMap { recipeID in
                recipes.first(where: { $0.id == recipeID })
            }
            .flatMap { $0.ingredients }
        }

        let grouped = Dictionary(grouping: items, by: { $0.name })
        let shoppingItems = grouped.map { name, ingredients -> ShoppingItem in
            let total = ingredients.reduce(0) { $0 + $1.amount }
            let unit = ingredients.first?.unit ?? ""
            let category = ingredients.first?.category ?? "Sonstiges"
            return ShoppingItem(id: UUID(), name: name, quantity: total, unit: unit, isChecked: false, category: category)
        }
        .sorted { $0.category < $1.category }

        shoppingListStore.updateItems(shoppingItems)
        self.items = shoppingItems
    }
}
