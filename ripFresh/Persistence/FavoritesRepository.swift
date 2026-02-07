import CoreData

protocol FavoritesRepositoryProtocol {
    func fetchAll() throws -> [FavoriteRecipe]
    func isFavorite(recipeID: String) throws -> Bool
    func add(recipeID: String) throws
    func remove(recipeID: String) throws
    func removeAll() throws
}

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() throws -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return try context.fetch(request)
    }

    func isFavorite(recipeID: String) throws -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@", recipeID)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }

    func add(recipeID: String) throws {
        guard try !isFavorite(recipeID: recipeID) else { return }
        let favorite = FavoriteRecipe(context: context)
        favorite.recipeID = recipeID
        favorite.createdAt = Date()
        try context.saveIfNeeded()
    }

    func remove(recipeID: String) throws {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@", recipeID)
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }

    func removeAll() throws {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }
}
