import Foundation

struct Step: Codable, Hashable, Sendable {
    let index: Int
    let instruction: String
    let durationMinutes: Int?

    init(index: Int, instruction: String, durationMinutes: Int?) {
        self.index = index
        self.instruction = instruction
        self.durationMinutes = durationMinutes
    }
}
