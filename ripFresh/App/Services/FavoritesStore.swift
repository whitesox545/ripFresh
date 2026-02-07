import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<UUID> = []
    private let filename = "favorites.json"

    init() {
        if let stored: [UUID] = LocalPersistence.load([UUID].self, from: filename) {
            favoriteIDs = Set(stored)
        }
    }

    func toggleFavorite(_ id: UUID) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        persist()
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoriteIDs.contains(id)
    }

    private func persist() {
        LocalPersistence.save(Array(favoriteIDs), to: filename)
    }
}
