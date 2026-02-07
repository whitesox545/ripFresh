import SwiftUI

final class ShoppingListViewModel: ObservableObject {
    @Published var items: [String] = [
        "Paprika",
        "Tomaten",
        "Quinoa",
        "Halloumi",
        "Kokosmilch",
        "Reis"
    ]

    @Published var itemChecks: [Bool] = [false, false, true, false, false, true]

    func toggleItem(at index: Int) {
        itemChecks[index].toggle()
    }
}

struct ShoppingListView: View {
    @ObservedObject var viewModel: ShoppingListViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    Button {
                        viewModel.toggleItem(at: index)
                    } label: {
                        HStack {
                            Image(systemName: viewModel.itemChecks[index] ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(viewModel.itemChecks[index] ? Color.green : Color.secondary)
                            Text(viewModel.items[index])
                                .foregroundStyle(viewModel.itemChecks[index] ? Color.secondary : Color.primary)
                                .strikethrough(viewModel.itemChecks[index])
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
        }
    }
}
