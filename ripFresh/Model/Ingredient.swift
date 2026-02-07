import Foundation

struct Ingredient: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
    let quantity: Quantity?
    let isOptional: Bool
    let notes: String?

    init(id: String, name: String, quantity: Quantity?, isOptional: Bool, notes: String?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isOptional = isOptional
        self.notes = notes
    }
}
