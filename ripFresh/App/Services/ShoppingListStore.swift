import Foundation

@MainActor
final class ShoppingListStore: ObservableObject {
    @Published private(set) var items: [ShoppingItem] = []
    private let filename = "shopping_list.json"

    init() {
        if let stored: [ShoppingItem] = LocalPersistence.load([ShoppingItem].self, from: filename) {
            items = stored
        }
    }

    func updateItems(_ newItems: [ShoppingItem]) {
        items = newItems
        persist()
    }

    func toggleItem(_ item: ShoppingItem) {
        guard let index = items.firstIndex(of: item) else { return }
        items[index].isChecked.toggle()
        persist()
    }

    func addManualItem(name: String) {
        let newItem = ShoppingItem(id: UUID(), name: name, quantity: 1, unit: "x", isChecked: false, category: "Sonstiges")
        items.insert(newItem, at: 0)
        persist()
    }

    private func persist() {
        LocalPersistence.save(items, to: filename)
    }
}
