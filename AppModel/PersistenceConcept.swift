import Foundation

struct FavoriteRecipe: Codable, Hashable {
    let recipeId: String
    let createdAt: Date
}

struct WeeklyPlanEntry: Codable, Hashable {
    let recipeId: String
    let scheduledDate: Date
    let mealSlot: MealSlot
}

enum MealSlot: String, Codable {
    case breakfast
    case lunch
    case dinner
    case snack
}

struct ShoppingListItem: Codable, Hashable {
    let id: UUID
    let name: String
    let quantity: String?
    let note: String?
    let isChecked: Bool
}

struct ShoppingList: Codable, Hashable {
    let id: UUID
    let title: String
    let createdAt: Date
    let items: [ShoppingListItem]
}

protocol RecipePersistenceStore {
    func loadFavorites() throws -> [FavoriteRecipe]
    func saveFavorites(_ favorites: [FavoriteRecipe]) throws

    func loadWeeklyPlan() throws -> [WeeklyPlanEntry]
    func saveWeeklyPlan(_ entries: [WeeklyPlanEntry]) throws

    func loadShoppingLists() throws -> [ShoppingList]
    func saveShoppingLists(_ lists: [ShoppingList]) throws
}

struct FileBasedRecipePersistenceStore: RecipePersistenceStore {
    let baseURL: URL
    let encoder: JSONEncoder
    let decoder: JSONDecoder

    init(baseURL: URL) {
        self.baseURL = baseURL
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func loadFavorites() throws -> [FavoriteRecipe] {
        try load(from: "favorites.json")
    }

    func saveFavorites(_ favorites: [FavoriteRecipe]) throws {
        try save(favorites, to: "favorites.json")
    }

    func loadWeeklyPlan() throws -> [WeeklyPlanEntry] {
        try load(from: "weekly-plan.json")
    }

    func saveWeeklyPlan(_ entries: [WeeklyPlanEntry]) throws {
        try save(entries, to: "weekly-plan.json")
    }

    func loadShoppingLists() throws -> [ShoppingList] {
        try load(from: "shopping-lists.json")
    }

    func saveShoppingLists(_ lists: [ShoppingList]) throws {
        try save(lists, to: "shopping-lists.json")
    }

    private func load<T: Decodable>(from filename: String) throws -> T {
        let url = baseURL.appendingPathComponent(filename)
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }

    private func save<T: Encodable>(_ value: T, to filename: String) throws {
        let url = baseURL.appendingPathComponent(filename)
        let data = try encoder.encode(value)
        try data.write(to: url, options: [.atomic])
    }
}
