import SwiftUI

struct MealPlanView: View {
    @ObservedObject var viewModel: MealPlanViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                ForEach(viewModel.mealPlan.days) { day in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(day.date, style: .date)
                                .font(AppTheme.subtitleFont())
                            Spacer()
                            Button("Zurücksetzen") {
                                viewModel.resetWeek()
                            }
                            .font(AppTheme.captionFont())
                            .foregroundColor(AppTheme.secondaryText)
                        }

                        if day.recipeIDs.isEmpty {
                            Text("Ziehe ein Rezept aus der Übersicht oder füge es im Detail hinzu.")
                                .font(AppTheme.bodyFont())
                                .foregroundColor(AppTheme.secondaryText)
                        } else {
                            ForEach(day.recipeIDs, id: \.self) { recipeID in
                                if let recipe = viewModel.recipe(for: recipeID) {
                                    HStack {
                                        RecipeRowView(
                                            recipe: recipe,
                                            isFavorite: viewModel.isFavorite(recipe.id),
                                            onFavoriteTapped: { viewModel.toggleFavorite(recipe.id) }
                                        )
                                        Button(action: {
                                            viewModel.removeRecipe(recipe.id, from: day)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(AppTheme.secondaryText)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .calmCard()
                }

                Button(action: viewModel.refreshShoppingList) {
                    Text("Einkaufsliste aus Plan aktualisieren")
                        .font(AppTheme.subtitleFont())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(AppTheme.horizontalPadding)
        }
        .navigationTitle("Wochenplanung")
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Deine Woche im Blick")
                .font(AppTheme.titleFont())
            Text("Plane offline, damit du im Supermarkt und in der Küche schnell Zugriff hast.")
                .font(AppTheme.bodyFont())
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
