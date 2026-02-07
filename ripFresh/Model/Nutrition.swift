import Foundation

struct Nutrition: Codable, Hashable, Sendable {
    let calories: Double?
    let proteinGrams: Double?
    let fatGrams: Double?
    let saturatedFatGrams: Double?
    let carbohydratesGrams: Double?
    let sugarGrams: Double?
    let fiberGrams: Double?
    let sodiumMilligrams: Double?

    init(
        calories: Double?,
        proteinGrams: Double?,
        fatGrams: Double?,
        saturatedFatGrams: Double?,
        carbohydratesGrams: Double?,
        sugarGrams: Double?,
        fiberGrams: Double?,
        sodiumMilligrams: Double?
    ) {
        self.calories = calories
        self.proteinGrams = proteinGrams
        self.fatGrams = fatGrams
        self.saturatedFatGrams = saturatedFatGrams
        self.carbohydratesGrams = carbohydratesGrams
        self.sugarGrams = sugarGrams
        self.fiberGrams = fiberGrams
        self.sodiumMilligrams = sodiumMilligrams
    }
}
