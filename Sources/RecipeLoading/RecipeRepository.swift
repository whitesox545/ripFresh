import Foundation

public protocol RecipeRepository {
    func loadRecipes() throws -> [Recipe]
    func loadRecipes() async throws -> [Recipe]
}

public extension RecipeRepository {
    func loadRecipes() async throws -> [Recipe] {
        try await Task.detached(priority: .userInitiated) {
            try loadRecipes()
        }.value
    }
}

public final class BundleRecipeRepository: RecipeRepository {
    private let bundle: Bundle
    private let resourceName: String
    private let resourceExtension: String
    private let decoder: JSONDecoder

    public init(
        bundle: Bundle = .main,
        resourceName: String,
        resourceExtension: String = "json",
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.bundle = bundle
        self.resourceName = resourceName
        self.resourceExtension = resourceExtension
        self.decoder = decoder
    }

    public func loadRecipes() throws -> [Recipe] {
        guard let resourceURL = bundle.url(forResource: resourceName, withExtension: resourceExtension) else {
            throw RecipeLoadingError.resourceNotFound(resource: resourceName, fileExtension: resourceExtension)
        }

        let data: Data
        do {
            data = try Data(contentsOf: resourceURL)
        } catch {
            throw RecipeLoadingError.dataReadFailed(resourceURL: resourceURL, underlyingError: error)
        }

        do {
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            throw RecipeLoadingError.decodingFailed(resourceURL: resourceURL, underlyingError: error)
        }
    }
}
