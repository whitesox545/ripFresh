import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RecipeImageView(imageName: recipe.imageName)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(10)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(12)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(AppTheme.subtitleFont())
                    .foregroundColor(.primary)

                Text(recipe.summary)
                    .font(AppTheme.bodyFont())
                    .foregroundColor(AppTheme.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label(recipe.durationText, systemImage: "clock")
                    Label("\(recipe.servings) Portionen", systemImage: "person.2")
                    Label(recipe.difficulty.rawValue, systemImage: "flame")
                }
                .font(AppTheme.captionFont())
                .foregroundColor(AppTheme.secondaryText)
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 12)
        }
        .calmCard()
    }
}
