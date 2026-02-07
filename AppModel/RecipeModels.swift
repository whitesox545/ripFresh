import Foundation

struct RecipeIndex: Decodable {
    let schemaVersion: Int
    let generatedAt: Date
    let source: RecipeSource
    let recipes: [Recipe]
    let stats: RecipeStats
}

struct RecipeSource: Decodable {
    let root: String
    let note: String
}

struct Recipe: Decodable {
    let id: String
    let slug: String
    let pdf: RecipePDF
}

struct RecipePDF: Decodable {
    let path: String
    let sha256: String
    let byteSize: Int
}

struct RecipeStats: Decodable {
    let recipeCount: Int
}
