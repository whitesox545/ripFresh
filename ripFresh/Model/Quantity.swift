import Foundation

struct Quantity: Codable, Hashable, Sendable {
    let value: Double
    let unit: MeasurementUnit?

    init(value: Double, unit: MeasurementUnit?) {
        self.value = value
        self.unit = unit
    }
}

enum MeasurementUnit: String, Codable, Hashable, Sendable {
    case gram
    case kilogram
    case milliliter
    case liter
    case piece
    case teaspoon
    case tablespoon
    case pinch
    case cup
    case clove
    case slice
    case package
}
