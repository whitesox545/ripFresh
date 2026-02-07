import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let amount: Double
    let unit: String
    let category: String

    var formattedAmount: String {
        let trimmed = amount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(amount)) : String(format: "%.1f", amount)
        return "\(trimmed) \(unit)"
    }
}
