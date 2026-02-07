import Foundation

public struct Recipe: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public var title: String
    public var summary: String
    public var imageName: String?
    public var tags: [String]
    public var durationMinutes: Int
    public var servings: Int
    public var ingredients: [Ingredient]
    public var steps: [CookingStep]

    public init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        imageName: String? = nil,
        tags: [String] = [],
        durationMinutes: Int,
        servings: Int,
        ingredients: [Ingredient],
        steps: [CookingStep]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.imageName = imageName
        self.tags = tags
        self.durationMinutes = durationMinutes
        self.servings = servings
        self.ingredients = ingredients
        self.steps = steps
    }
}

public struct Ingredient: Codable, Equatable, Hashable {
    public var name: String
    public var quantity: Double
    public var unit: String

    public init(name: String, quantity: Double, unit: String) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}

public struct CookingStep: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public var index: Int
    public var instruction: String
    public var durationMinutes: Int?

    public init(id: UUID = UUID(), index: Int, instruction: String, durationMinutes: Int? = nil) {
        self.id = id
        self.index = index
        self.instruction = instruction
        self.durationMinutes = durationMinutes
    }
}

public struct SearchFilter: Codable, Equatable, Hashable {
    public var query: String
    public var tags: Set<String>
    public var maxDurationMinutes: Int?
    public var favoriteOnly: Bool

    public init(query: String = "", tags: Set<String> = [], maxDurationMinutes: Int? = nil, favoriteOnly: Bool = false) {
        self.query = query
        self.tags = tags
        self.maxDurationMinutes = maxDurationMinutes
        self.favoriteOnly = favoriteOnly
    }
}

public enum Weekday: String, Codable, CaseIterable, Hashable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

public struct PlannedRecipe: Codable, Equatable, Hashable {
    public var recipeId: UUID
    public var servings: Int

    public init(recipeId: UUID, servings: Int) {
        self.recipeId = recipeId
        self.servings = servings
    }
}

public struct WeeklyPlan: Codable, Equatable, Hashable {
    public var days: [Weekday: [PlannedRecipe]]

    public init(days: [Weekday: [PlannedRecipe]] = [:]) {
        self.days = days
    }
}

public struct ShoppingListItem: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public var name: String
    public var quantity: Double
    public var unit: String
    public var isChecked: Bool
    public var sourceRecipeId: UUID?

    public init(
        id: UUID = UUID(),
        name: String,
        quantity: Double,
        unit: String,
        isChecked: Bool = false,
        sourceRecipeId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.isChecked = isChecked
        self.sourceRecipeId = sourceRecipeId
    }
}

public struct CookingSessionState: Codable, Equatable, Hashable {
    public var recipeId: UUID
    public var currentStepIndex: Int
    public var servings: Int

    public init(recipeId: UUID, currentStepIndex: Int = 0, servings: Int) {
        self.recipeId = recipeId
        self.currentStepIndex = currentStepIndex
        self.servings = servings
    }
}
