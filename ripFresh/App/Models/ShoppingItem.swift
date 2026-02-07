import Foundation

struct ShoppingItem: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let quantity: Double
    let unit: String
    var isChecked: Bool
    let category: String

    var displayQuantity: String {
        let trimmed = quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(quantity)) : String(format: "%.1f", quantity)
        return "\(trimmed) \(unit)"
    }
}
