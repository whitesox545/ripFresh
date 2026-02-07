import CoreData

protocol ShoppingListRepositoryProtocol {
    func fetchAll() throws -> [ShoppingListItem]
    func addItem(recipeID: String, ingredientID: String) throws
    func removeItem(recipeID: String, ingredientID: String) throws
    func toggleItem(recipeID: String, ingredientID: String) throws
    func removeAll() throws
}

final class ShoppingListRepository: ShoppingListRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [ShoppingListItem] {
        let request: NSFetchRequest<ShoppingListItem> = ShoppingListItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "isChecked", ascending: true),
            NSSortDescriptor(key: "addedAt", ascending: false)
        ]
        return try context.fetch(request)
    }

    func addItem(recipeID: String, ingredientID: String) throws {
        guard try !exists(recipeID: recipeID, ingredientID: ingredientID) else { return }
        let item = ShoppingListItem(context: context)
        item.recipeID = recipeID
        item.ingredientID = ingredientID
        item.addedAt = Date()
        item.isChecked = false
        try context.saveIfNeeded()
    }

    func removeItem(recipeID: String, ingredientID: String) throws {
        let request: NSFetchRequest<ShoppingListItem> = ShoppingListItem.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@ AND ingredientID == %@", recipeID, ingredientID)
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }

    func toggleItem(recipeID: String, ingredientID: String) throws {
        let request: NSFetchRequest<ShoppingListItem> = ShoppingListItem.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@ AND ingredientID == %@", recipeID, ingredientID)
        request.fetchLimit = 1
        if let item = try context.fetch(request).first {
            item.isChecked.toggle()
            try context.saveIfNeeded()
        }
    }

    func removeAll() throws {
        let request: NSFetchRequest<ShoppingListItem> = ShoppingListItem.fetchRequest()
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }

    private func exists(recipeID: String, ingredientID: String) throws -> Bool {
        let request: NSFetchRequest<ShoppingListItem> = ShoppingListItem.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@ AND ingredientID == %@", recipeID, ingredientID)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }
}
