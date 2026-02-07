import CoreData

@objc(FavoriteRecipe)
final class FavoriteRecipe: NSManagedObject {
    @NSManaged var recipeID: String
    @NSManaged var createdAt: Date
}

@objc(PlannedRecipe)
final class PlannedRecipe: NSManagedObject {
    @NSManaged var recipeID: String
    @NSManaged var plannedDate: Date
    @NSManaged var createdAt: Date
}

@objc(ShoppingListItem)
final class ShoppingListItem: NSManagedObject {
    @NSManaged var recipeID: String
    @NSManaged var ingredientID: String
    @NSManaged var addedAt: Date
    @NSManaged var isChecked: Bool
}
