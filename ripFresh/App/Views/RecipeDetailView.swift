import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RecipeImageView(imageName: viewModel.recipe.imageName)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                header

                planActions

                detailStats

                ingredientsSection

                stepsSection
            }
            .padding(AppTheme.horizontalPadding)
        }
        .navigationTitle(viewModel.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite() ? "heart.fill" : "heart")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                CookModeView(viewModel: CookModeViewModel(recipe: viewModel.recipe))
            } label: {
                Text("Kochmodus starten")
                    .font(AppTheme.subtitleFont())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.calmBlue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, AppTheme.horizontalPadding)
                    .padding(.bottom, 12)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.recipe.summary)
                .font(AppTheme.bodyFont())
                .foregroundColor(AppTheme.secondaryText)

            HStack(spacing: 12) {
                Label(viewModel.recipe.durationText, systemImage: "clock")
                Label("\(viewModel.recipe.servings) Portionen", systemImage: "person.2")
                Label(viewModel.recipe.difficulty.rawValue, systemImage: "flame")
                Label("\(viewModel.recipe.calories) kcal", systemImage: "bolt.heart")
            }
            .font(AppTheme.captionFont())
            .foregroundColor(AppTheme.secondaryText)
        }
    }

    private var detailStats: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(AppTheme.subtitleFont())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.recipe.tags, id: \\.self) { tag in
                        Text(tag)
                            .font(AppTheme.captionFont())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var planActions: some View {
        HStack(spacing: 12) {
            Menu {
                ForEach(viewModel.planDays) { day in
                    Button(action: {
                        viewModel.addToPlan(day: day)
                    }) {
                        Text(day.date, style: .date)
                    }
                }
            } label: {
                Label("Zum Plan hinzufügen", systemImage: "calendar.badge.plus")
                    .font(AppTheme.bodyFont().weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Spacer()
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Zutaten")
                .font(AppTheme.subtitleFont())

            ForEach(viewModel.recipe.ingredients) { ingredient in
                HStack {
                    Text(ingredient.name)
                    Spacer()
                    Text(ingredient.formattedAmount)
                        .foregroundColor(AppTheme.secondaryText)
                }
                .font(AppTheme.bodyFont())
                Divider()
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Zubereitung")
                .font(AppTheme.subtitleFont())

            ForEach(viewModel.recipe.steps) { step in
                VStack(alignment: .leading, spacing: 6) {
                    Text(step.title)
                        .font(AppTheme.bodyFont().weight(.semibold))
                    Text(step.instructions)
                        .font(AppTheme.bodyFont())
                        .foregroundColor(AppTheme.secondaryText)
                    Text("ca. \(step.durationMinutes) Min")
                        .font(AppTheme.captionFont())
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding()
                .calmCard()
            }
        }
    }
}
