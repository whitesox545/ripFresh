import Foundation

@MainActor
final class MealPlanStore: ObservableObject {
    @Published private(set) var mealPlan: MealPlan
    private let filename = "meal_plan.json"

    init() {
        if let stored: MealPlan = LocalPersistence.load(MealPlan.self, from: filename) {
            mealPlan = stored
        } else {
            mealPlan = MealPlan.emptyWeek(startingFrom: Date())
        }
    }

    func addRecipe(_ id: UUID, to day: PlanDay) {
        guard let index = mealPlan.days.firstIndex(where: { $0.id == day.id }) else {
            return
        }
        if !mealPlan.days[index].recipeIDs.contains(id) {
            mealPlan.days[index].recipeIDs.append(id)
            persist()
        }
    }

    func removeRecipe(_ id: UUID, from day: PlanDay) {
        guard let index = mealPlan.days.firstIndex(where: { $0.id == day.id }) else {
            return
        }
        mealPlan.days[index].recipeIDs.removeAll { $0 == id }
        persist()
    }

    func replaceWeek(startingFrom date: Date) {
        mealPlan = MealPlan.emptyWeek(startingFrom: date)
        persist()
    }

    private func persist() {
        LocalPersistence.save(mealPlan, to: filename)
    }
}
