import Foundation

@MainActor
final class CookModeViewModel: ObservableObject {
    @Published private(set) var recipe: Recipe
    @Published var currentStepIndex = 0
    @Published var keepScreenAwake = true

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    var currentStep: RecipeStep {
        recipe.steps[currentStepIndex]
    }

    var progressText: String {
        "Schritt \(currentStepIndex + 1) von \(recipe.steps.count)"
    }

    func goToNext() {
        if currentStepIndex < recipe.steps.count - 1 {
            currentStepIndex += 1
        }
    }

    func goToPrevious() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
}
