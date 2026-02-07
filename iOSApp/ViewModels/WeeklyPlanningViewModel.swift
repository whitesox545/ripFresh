import Foundation
import Combine

@MainActor
public final class WeeklyPlanningViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<WeeklyPlan> = .idle
    @Published public private(set) var plan: WeeklyPlan

    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(loader: RecipeLoading, persistence: PersistenceStore) {
        self.loader = loader
        self.persistence = persistence
        self.plan = persistence.loadWeeklyPlan()
    }

    public func load() async {
        state = .loading
        plan = persistence.loadWeeklyPlan()
        state = .loaded(plan)
    }

    public func add(recipeId: UUID, to day: Weekday, servings: Int) {
        var dayRecipes = plan.days[day, default: []]
        dayRecipes.append(PlannedRecipe(recipeId: recipeId, servings: servings))
        plan.days[day] = dayRecipes
        persistence.saveWeeklyPlan(plan)
        state = .loaded(plan)
    }

    public func remove(recipeId: UUID, from day: Weekday) {
        var dayRecipes = plan.days[day, default: []]
        dayRecipes.removeAll { $0.recipeId == recipeId }
        plan.days[day] = dayRecipes
        persistence.saveWeeklyPlan(plan)
        state = .loaded(plan)
    }

    public func recipeTitle(for recipeId: UUID) async -> String? {
        do {
            return try await loader.loadRecipe(id: recipeId)?.title
        } catch {
            return nil
        }
    }
}
