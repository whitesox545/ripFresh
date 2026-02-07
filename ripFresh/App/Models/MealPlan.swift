import Foundation

struct PlanDay: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var recipeIDs: [UUID]
}

struct MealPlan: Codable, Hashable {
    var days: [PlanDay]

    static func emptyWeek(startingFrom date: Date) -> MealPlan {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let days = (0..<7).map { offset -> PlanDay in
            let nextDate = calendar.date(byAdding: .day, value: offset, to: start) ?? start
            return PlanDay(id: UUID(), date: nextDate, recipeIDs: [])
        }
        return MealPlan(days: days)
    }
}
