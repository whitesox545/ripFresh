import SwiftUI

@main
struct RipFreshApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: RootViewModel())
        }
    }
}

final class RootViewModel: ObservableObject {
    @Published var selectedTab: RootTab = .recipes
}

enum RootTab: Hashable {
    case recipes
    case search
    case favorites
    case plan
    case shopping
}
