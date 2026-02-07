import Foundation
import Combine

@MainActor
public final class SearchFilterViewModel: ObservableObject {
    @Published public private(set) var state: ViewModelState<SearchFilter> = .idle
    @Published public var filter: SearchFilter

    private let persistence: PersistenceStore

    public init(persistence: PersistenceStore) {
        self.persistence = persistence
        self.filter = persistence.loadSearchFilter()
        state = .loaded(filter)
    }

    public func updateFilter(_ update: (inout SearchFilter) -> Void) {
        update(&filter)
        persistence.saveSearchFilter(filter)
        state = .loaded(filter)
    }

    public func resetFilter() {
        filter = SearchFilter()
        persistence.saveSearchFilter(filter)
        state = .loaded(filter)
    }
}
