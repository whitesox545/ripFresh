import SwiftUI

struct SearchFilterView: View {
    @ObservedObject var viewModel: SearchFilterViewModel

    var body: some View {
        VStack(spacing: 0) {
            filterControls

            List {
                ForEach(viewModel.filteredRecipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(viewModel: viewModel.detailViewModel(for: recipe))
                    } label: {
                        RecipeRowView(
                            recipe: recipe,
                            isFavorite: viewModel.isFavorite(recipe.id),
                            onFavoriteTapped: { viewModel.toggleFavorite(recipe.id) }
                        )
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Suche & Filter")
        .searchable(text: $viewModel.filter.query, placement: .navigationBarDrawer(displayMode: .always))
        .task {
            await viewModel.load()
        }
    }

    private var filterControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter")
                .font(AppTheme.subtitleFont())
                .padding(.horizontal, AppTheme.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Difficulty.allCases, id: \\.self) { difficulty in
                        FilterChipView(
                            title: difficulty.rawValue,
                            isSelected: viewModel.filter.difficulty == difficulty,
                            action: {
                                viewModel.filter.difficulty = viewModel.filter.difficulty == difficulty ? nil : difficulty
                            }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.availableTags, id: \\.self) { tag in
                        FilterChipView(
                            title: tag,
                            isSelected: viewModel.filter.selectedTags.contains(tag),
                            action: {
                                if viewModel.filter.selectedTags.contains(tag) {
                                    viewModel.filter.selectedTags.remove(tag)
                                } else {
                                    viewModel.filter.selectedTags.insert(tag)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)
            }

            HStack {
                Text("Max. Zeit")
                    .font(AppTheme.captionFont())
                Spacer()
                Text(viewModel.filter.maxTime.map { "\($0) Min" } ?? "Beliebig")
                    .font(AppTheme.captionFont())
                    .foregroundColor(AppTheme.secondaryText)
            }
            .padding(.horizontal, AppTheme.horizontalPadding)

            Slider(value: Binding(
                get: { Double(viewModel.filter.maxTime ?? 60) },
                set: { viewModel.filter.maxTime = Int($0) }
            ), in: 15...90, step: 5)
            .padding(.horizontal, AppTheme.horizontalPadding)
        }
        .padding(.vertical, AppTheme.verticalPadding)
        .background(Color(.secondarySystemBackground))
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            RecipeImageView(imageName: recipe.imageName)
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(AppTheme.subtitleFont())
                Text(recipe.summary)
                    .font(AppTheme.captionFont())
                    .foregroundColor(AppTheme.secondaryText)
                Text("\(recipe.durationText) · \(recipe.difficulty.rawValue)")
                    .font(AppTheme.captionFont())
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer()

            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : AppTheme.secondaryText)
            }
        }
        .padding(.vertical, 8)
    }
}
