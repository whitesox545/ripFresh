import Foundation
import Combine

@MainActor
public final class CookingModeViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<Recipe> = .idle
    @Published public private(set) var currentStepIndex: Int = 0
    @Published public private(set) var servings: Int = 1

    private let recipeId: UUID
    private let loader: RecipeLoading
    private let persistence: PersistenceStore

    public init(recipeId: UUID, loader: RecipeLoading, persistence: PersistenceStore) {
        self.recipeId = recipeId
        self.loader = loader
        self.persistence = persistence
    }

    public func load() async {
        state = .loading
        do {
            if let recipe = try await loader.loadRecipe(id: recipeId) {
                let session = persistence.loadCookingSession(recipeId: recipeId)
                let restoredStep = session?.currentStepIndex ?? 0
                let restoredServings = session?.servings ?? recipe.servings
                currentStepIndex = min(max(restoredStep, 0), max(recipe.steps.count - 1, 0))
                servings = max(restoredServings, 1)
                state = .loaded(recipe)
            } else {
                state = .empty
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    public func advanceStep() {
        guard case let .loaded(recipe) = state else { return }
        let nextIndex = min(currentStepIndex + 1, max(recipe.steps.count - 1, 0))
        updateSession(stepIndex: nextIndex, servings: servings)
    }

    public func previousStep() {
        let prevIndex = max(currentStepIndex - 1, 0)
        updateSession(stepIndex: prevIndex, servings: servings)
    }

    public func updateServings(_ newServings: Int) {
        let safeServings = max(newServings, 1)
        updateSession(stepIndex: currentStepIndex, servings: safeServings)
    }

    public func resetSession() {
        currentStepIndex = 0
        persistence.clearCookingSession(recipeId: recipeId)
    }

    private func updateSession(stepIndex: Int, servings: Int) {
        currentStepIndex = stepIndex
        self.servings = servings
        let session = CookingSessionState(recipeId: recipeId, currentStepIndex: stepIndex, servings: servings)
        persistence.saveCookingSession(session)
    }
}
