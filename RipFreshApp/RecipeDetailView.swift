import SwiftUI

final class RecipeDetailViewModel: ObservableObject {
    let recipeName: String
    let subtitle: String
    let timeLabel: String
    let tagLabel: String
    let symbolName: String
    let ingredients: [String]
    let steps: [String]

    init(
        recipeName: String,
        subtitle: String,
        timeLabel: String,
        tagLabel: String,
        symbolName: String,
        ingredients: [String],
        steps: [String]
    ) {
        self.recipeName = recipeName
        self.subtitle = subtitle
        self.timeLabel = timeLabel
        self.tagLabel = tagLabel
        self.symbolName = symbolName
        self.ingredients = ingredients
        self.steps = steps
    }

    func cookingModeViewModel() -> CookingModeViewModel {
        CookingModeViewModel(recipeName: recipeName, steps: steps)
    }
}

struct RecipeDetailView: View {
    @ObservedObject var viewModel: RecipeDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.recipeName)
                        .font(.largeTitle.weight(.bold))
                    Text(viewModel.subtitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        Label(viewModel.timeLabel, systemImage: "clock")
                        Label(viewModel.tagLabel, systemImage: "tag")
                    }
                    .font(.subheadline.weight(.semibold))
                }

                sectionTitle("Zutaten")
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.body)
                    }
                }

                sectionTitle("Zubereitung")
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.steps.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.headline)
                                .frame(width: 28, height: 28)
                                .background(Color.primary.opacity(0.1))
                                .clipShape(Circle())
                            Text(viewModel.steps[index])
                                .font(.body)
                        }
                    }
                }

                NavigationLink {
                    CookingModeView(viewModel: viewModel.cookingModeViewModel())
                } label: {
                    Text("Kochmodus starten")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundStyle(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(20)
        }
        .navigationTitle("Rezeptdetail")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 260)

            Image(systemName: viewModel.symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.white.opacity(0.85))
                .padding(20)
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title2.weight(.bold))
    }
}
