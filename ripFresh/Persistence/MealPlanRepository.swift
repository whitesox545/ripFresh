import CoreData

protocol MealPlanRepositoryProtocol {
    func fetchAll() throws -> [PlannedRecipe]
    func fetchPlanned(on date: Date) throws -> [PlannedRecipe]
    func add(recipeID: String, for date: Date) throws
    func remove(recipeID: String, for date: Date) throws
    func removeAll() throws
}

final class MealPlanRepository: MealPlanRepositoryProtocol {
    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(context: NSManagedObjectContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }

    func fetchAll() throws -> [PlannedRecipe] {
        let request: NSFetchRequest<PlannedRecipe> = PlannedRecipe.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "plannedDate", ascending: true),
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        return try context.fetch(request)
    }

    func fetchPlanned(on date: Date) throws -> [PlannedRecipe] {
        let dayRange = calendar.startOfDay(for: date)...calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date))!
        let request: NSFetchRequest<PlannedRecipe> = PlannedRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "plannedDate >= %@ AND plannedDate < %@", dayRange.lowerBound as NSDate, dayRange.upperBound as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return try context.fetch(request)
    }

    func add(recipeID: String, for date: Date) throws {
        let plannedDate = calendar.startOfDay(for: date)
        guard try !exists(recipeID: recipeID, plannedDate: plannedDate) else { return }
        let planned = PlannedRecipe(context: context)
        planned.recipeID = recipeID
        planned.plannedDate = plannedDate
        planned.createdAt = Date()
        try context.saveIfNeeded()
    }

    func remove(recipeID: String, for date: Date) throws {
        let plannedDate = calendar.startOfDay(for: date)
        let request: NSFetchRequest<PlannedRecipe> = PlannedRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@ AND plannedDate == %@", recipeID, plannedDate as NSDate)
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }

    func removeAll() throws {
        let request: NSFetchRequest<PlannedRecipe> = PlannedRecipe.fetchRequest()
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.saveIfNeeded()
    }

    private func exists(recipeID: String, plannedDate: Date) throws -> Bool {
        let request: NSFetchRequest<PlannedRecipe> = PlannedRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@ AND plannedDate == %@", recipeID, plannedDate as NSDate)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }
}
