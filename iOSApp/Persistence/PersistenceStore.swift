import Foundation

public protocol PersistenceStore {
    func loadFavorites() -> Set<UUID>
    func saveFavorites(_ favorites: Set<UUID>)

    func loadSearchFilter() -> SearchFilter
    func saveSearchFilter(_ filter: SearchFilter)

    func loadWeeklyPlan() -> WeeklyPlan
    func saveWeeklyPlan(_ plan: WeeklyPlan)

    func loadShoppingList() -> [ShoppingListItem]
    func saveShoppingList(_ items: [ShoppingListItem])

    func loadCookingSession(recipeId: UUID) -> CookingSessionState?
    func saveCookingSession(_ session: CookingSessionState)
    func clearCookingSession(recipeId: UUID)
}

public final class UserDefaultsPersistenceStore: PersistenceStore {
    private let userDefaults: UserDefaults

    private enum Keys {
        static let favorites = "favorites"
        static let searchFilter = "searchFilter"
        static let weeklyPlan = "weeklyPlan"
        static let shoppingList = "shoppingList"
        static let cookingSessions = "cookingSessions"
    }

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func loadFavorites() -> Set<UUID> {
        decode(Set<UUID>.self, forKey: Keys.favorites) ?? []
    }

    public func saveFavorites(_ favorites: Set<UUID>) {
        encode(favorites, forKey: Keys.favorites)
    }

    public func loadSearchFilter() -> SearchFilter {
        decode(SearchFilter.self, forKey: Keys.searchFilter) ?? SearchFilter()
    }

    public func saveSearchFilter(_ filter: SearchFilter) {
        encode(filter, forKey: Keys.searchFilter)
    }

    public func loadWeeklyPlan() -> WeeklyPlan {
        decode(WeeklyPlan.self, forKey: Keys.weeklyPlan) ?? WeeklyPlan()
    }

    public func saveWeeklyPlan(_ plan: WeeklyPlan) {
        encode(plan, forKey: Keys.weeklyPlan)
    }

    public func loadShoppingList() -> [ShoppingListItem] {
        decode([ShoppingListItem].self, forKey: Keys.shoppingList) ?? []
    }

    public func saveShoppingList(_ items: [ShoppingListItem]) {
        encode(items, forKey: Keys.shoppingList)
    }

    public func loadCookingSession(recipeId: UUID) -> CookingSessionState? {
        let sessions = decode([UUID: CookingSessionState].self, forKey: Keys.cookingSessions) ?? [:]
        return sessions[recipeId]
    }

    public func saveCookingSession(_ session: CookingSessionState) {
        var sessions = decode([UUID: CookingSessionState].self, forKey: Keys.cookingSessions) ?? [:]
        sessions[session.recipeId] = session
        encode(sessions, forKey: Keys.cookingSessions)
    }

    public func clearCookingSession(recipeId: UUID) {
        var sessions = decode([UUID: CookingSessionState].self, forKey: Keys.cookingSessions) ?? [:]
        sessions.removeValue(forKey: recipeId)
        encode(sessions, forKey: Keys.cookingSessions)
    }

    private func encode<T: Encodable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }

    private func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
