import Foundation

public enum RecipeLoadingError: LocalizedError {
    case resourceNotFound(resource: String, fileExtension: String)
    case dataReadFailed(resourceURL: URL, underlyingError: Error)
    case decodingFailed(resourceURL: URL, underlyingError: Error)

    public var errorDescription: String? {
        switch self {
        case let .resourceNotFound(resource, fileExtension):
            return "Missing recipe resource \(resource).\(fileExtension) in bundle."
        case let .dataReadFailed(resourceURL, _):
            return "Unable to read recipe data from \(resourceURL.lastPathComponent)."
        case let .decodingFailed(resourceURL, _):
            return "Unable to decode recipe data from \(resourceURL.lastPathComponent)."
        }
    }
}
