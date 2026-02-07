import CoreData

extension FavoriteRecipe {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }
}

extension PlannedRecipe {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<PlannedRecipe> {
        NSFetchRequest<PlannedRecipe>(entityName: "PlannedRecipe")
    }
}

extension ShoppingListItem {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<ShoppingListItem> {
        NSFetchRequest<ShoppingListItem>(entityName: "ShoppingListItem")
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
}
