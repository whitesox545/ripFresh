import Foundation

enum RecipeBundleLoader {
    static func loadIndex(from bundle: Bundle = .main, resourceName: String = "recipes") throws -> RecipeIndex {
        let url = try resourceURL(for: bundle, resourceName: resourceName, fileExtension: "json")
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(RecipeIndex.self, from: data)
    }

    static func loadPDFData(for recipe: Recipe, from bundle: Bundle = .main) throws -> Data {
        let url = try resourceURL(for: bundle, resourcePath: recipe.pdf.path)
        return try Data(contentsOf: url)
    }

    private static func resourceURL(for bundle: Bundle, resourceName: String, fileExtension: String) throws -> URL {
        guard let url = bundle.url(forResource: resourceName, withExtension: fileExtension) else {
            throw RecipeBundleError.missingResource(resourceName)
        }
        return url
    }

    private static func resourceURL(for bundle: Bundle, resourcePath: String) throws -> URL {
        let normalized = resourcePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let pathComponents = normalized.split(separator: "/")
        guard let filename = pathComponents.last else {
            throw RecipeBundleError.missingResource(resourcePath)
        }
        let subdirectory = pathComponents.dropLast().joined(separator: "/")
        let name = String(filename)
        let ext = URL(fileURLWithPath: name).pathExtension
        let base = URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent
        let url = bundle.url(forResource: base, withExtension: ext, subdirectory: subdirectory.isEmpty ? nil : subdirectory)
        guard let resolved = url else {
            throw RecipeBundleError.missingResource(resourcePath)
        }
        return resolved
    }
}

enum RecipeBundleError: Error, LocalizedError {
    case missingResource(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Resource not found in bundle: \(name)"
        }
    }
}
