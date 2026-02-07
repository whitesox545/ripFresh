import SwiftUI

final class RecipesOverviewViewModel: ObservableObject {
    let recipeNames: [String] = [
        "Bunte Quinoa-Bowl",
        "Cremiges Pilzrisotto",
        "Halloumi-Auberginen-Burger",
        "Asiatische Nudelpfanne",
        "Scharfes Curry",
        "Mediterraner Orzo-Auflauf",
        "Süßkartoffel-Tacos",
        "Tomatenrisotto"
    ]

    let recipeTimes: [String] = [
        "25 Min",
        "35 Min",
        "30 Min",
        "20 Min",
        "40 Min",
        "35 Min",
        "25 Min",
        "30 Min"
    ]

    let recipeTags: [String] = [
        "Vegetarisch",
        "Cremig",
        "Grill",
        "Schnell",
        "Scharf",
        "Ofen",
        "Streetfood",
        "Risotto"
    ]

    let recipeSymbols: [String] = [
        "leaf",
        "fork.knife",
        "flame",
        "bolt",
        "flame.fill",
        "oven",
        "tortoise",
        "drop"
    ]

    func detailViewModel(for index: Int) -> RecipeDetailViewModel {
        let name = recipeNames[index]
        let subtitle = "Offline verfügbar · iOS 16+"
        let ingredients = [
            "300 g Gemüse",
            "1 TL Gewürzmischung",
            "200 g Basis-Zutat",
            "1 EL Öl",
            "Salz & Pfeffer"
        ]
        let steps = [
            "Zutaten vorbereiten und schneiden.",
            "Öl erhitzen und Basis-Zutat anbraten.",
            "Gemüse hinzufügen und garen.",
            "Würzen, abschmecken und anrichten."
        ]
        return RecipeDetailViewModel(
            recipeName: name,
            subtitle: subtitle,
            timeLabel: recipeTimes[index],
            tagLabel: recipeTags[index],
            symbolName: recipeSymbols[index],
            ingredients: ingredients,
            steps: steps
        )
    }
}

struct RecipesOverviewView: View {
    @ObservedObject var viewModel: RecipesOverviewViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.recipeNames.indices, id: \.self) { index in
                            NavigationLink {
                                RecipeDetailView(viewModel: viewModel.detailViewModel(for: index))
                            } label: {
                                RecipeCardView(
                                    title: viewModel.recipeNames[index],
                                    subtitle: viewModel.recipeTimes[index],
                                    tag: viewModel.recipeTags[index],
                                    symbolName: viewModel.recipeSymbols[index]
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .navigationTitle("Rezeptübersicht")
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.8), Color.red.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 220)
                .overlay(
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.trailing, 16),
                    alignment: .topTrailing
                )

            VStack(alignment: .leading, spacing: 8) {
                Text("Heute kochen")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text("Offline First · Große Bilder · Schnell zur Hand")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(20)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct RecipeCardView: View {
    let title: String
    let subtitle: String
    let tag: String
    let symbolName: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.primary.opacity(0.08))
                Image(systemName: symbolName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.primary)
            }
            .frame(width: 88, height: 88)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                Text(tag)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.08))
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
    }
}
