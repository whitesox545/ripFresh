import CoreData

enum CoreDataModel {
    static let modelName = "RipFresh"

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let favoriteRecipeEntity = NSEntityDescription()
        favoriteRecipeEntity.name = "FavoriteRecipe"
        favoriteRecipeEntity.managedObjectClassName = NSStringFromClass(FavoriteRecipe.self)

        let favoriteRecipeID = NSAttributeDescription()
        favoriteRecipeID.name = "recipeID"
        favoriteRecipeID.attributeType = .stringAttributeType
        favoriteRecipeID.isOptional = false
        favoriteRecipeID.isIndexed = true

        let favoriteCreatedAt = NSAttributeDescription()
        favoriteCreatedAt.name = "createdAt"
        favoriteCreatedAt.attributeType = .dateAttributeType
        favoriteCreatedAt.isOptional = false

        favoriteRecipeEntity.properties = [favoriteRecipeID, favoriteCreatedAt]
        favoriteRecipeEntity.uniquenessConstraints = [["recipeID"]]

        let plannedRecipeEntity = NSEntityDescription()
        plannedRecipeEntity.name = "PlannedRecipe"
        plannedRecipeEntity.managedObjectClassName = NSStringFromClass(PlannedRecipe.self)

        let plannedRecipeID = NSAttributeDescription()
        plannedRecipeID.name = "recipeID"
        plannedRecipeID.attributeType = .stringAttributeType
        plannedRecipeID.isOptional = false
        plannedRecipeID.isIndexed = true

        let plannedDate = NSAttributeDescription()
        plannedDate.name = "plannedDate"
        plannedDate.attributeType = .dateAttributeType
        plannedDate.isOptional = false
        plannedDate.isIndexed = true

        let plannedCreatedAt = NSAttributeDescription()
        plannedCreatedAt.name = "createdAt"
        plannedCreatedAt.attributeType = .dateAttributeType
        plannedCreatedAt.isOptional = false

        plannedRecipeEntity.properties = [plannedRecipeID, plannedDate, plannedCreatedAt]
        plannedRecipeEntity.uniquenessConstraints = [["recipeID", "plannedDate"]]

        let shoppingListItemEntity = NSEntityDescription()
        shoppingListItemEntity.name = "ShoppingListItem"
        shoppingListItemEntity.managedObjectClassName = NSStringFromClass(ShoppingListItem.self)

        let shoppingRecipeID = NSAttributeDescription()
        shoppingRecipeID.name = "recipeID"
        shoppingRecipeID.attributeType = .stringAttributeType
        shoppingRecipeID.isOptional = false
        shoppingRecipeID.isIndexed = true

        let shoppingIngredientID = NSAttributeDescription()
        shoppingIngredientID.name = "ingredientID"
        shoppingIngredientID.attributeType = .stringAttributeType
        shoppingIngredientID.isOptional = false
        shoppingIngredientID.isIndexed = true

        let shoppingAddedAt = NSAttributeDescription()
        shoppingAddedAt.name = "addedAt"
        shoppingAddedAt.attributeType = .dateAttributeType
        shoppingAddedAt.isOptional = false

        let shoppingIsChecked = NSAttributeDescription()
        shoppingIsChecked.name = "isChecked"
        shoppingIsChecked.attributeType = .booleanAttributeType
        shoppingIsChecked.isOptional = false
        shoppingIsChecked.defaultValue = false

        shoppingListItemEntity.properties = [shoppingRecipeID, shoppingIngredientID, shoppingAddedAt, shoppingIsChecked]
        shoppingListItemEntity.uniquenessConstraints = [["recipeID", "ingredientID"]]

        model.entities = [favoriteRecipeEntity, plannedRecipeEntity, shoppingListItemEntity]

        return model
    }
}
