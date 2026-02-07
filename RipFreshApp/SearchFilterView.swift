import SwiftUI

final class SearchFilterViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var selectedFilter: String = "Alle"

    let filters: [String] = ["Alle", "Schnell", "Vegetarisch", "Scharf", "Ofen"]
    let allResults: [String] = [
        "Bunte Quinoa-Bowl",
        "Cremiges Pilzrisotto",
        "Halloumi-Auberginen-Burger",
        "Asiatische Nudelpfanne",
        "Scharfes Curry",
        "Mediterraner Orzo-Auflauf"
    ]

    var filteredResults: [String] {
        let base = selectedFilter == "Alle" ? allResults : allResults.filter { $0.localizedCaseInsensitiveContains(selectedFilter) }
        if query.isEmpty {
            return base
        }
        return base.filter { $0.localizedCaseInsensitiveContains(query) }
    }
}

struct SearchFilterView: View {
    @ObservedObject var viewModel: SearchFilterViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Filter") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.filters, id: \.self) { filter in
                                Button {
                                    viewModel.selectedFilter = filter
                                } label: {
                                    Text(filter)
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(viewModel.selectedFilter == filter ? Color.primary : Color.primary.opacity(0.1))
                                        )
                                        .foregroundStyle(viewModel.selectedFilter == filter ? Color(.systemBackground) : Color.primary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Ergebnisse") {
                    ForEach(viewModel.filteredResults, id: \.self) { result in
                        HStack {
                            Text(result)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Suche & Filter")
            .searchable(text: $viewModel.query)
        }
    }
}
