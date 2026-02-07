import SwiftUI

struct RecipeImageView: View {
    let imageName: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.calmBlue.opacity(0.9), Color.calmMint.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(imageName)
                .resizable()
                .scaledToFill()
                .opacity(0.6)

            VStack(spacing: 6) {
                Image(systemName: "fork.knife")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.9))
                Text("Frisch gekocht")
                    .font(AppTheme.captionFont())
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
}
