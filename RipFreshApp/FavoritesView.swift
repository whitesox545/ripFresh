import SwiftUI

final class FavoritesViewModel: ObservableObject {
    let favorites: [String] = [
        "Süßkartoffel-Tacos",
        "Cremiges Pilzrisotto",
        "Halloumi-Auberginen-Burger"
    ]
}

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.favorites, id: \.self) { favorite in
                        FavoriteRow(title: favorite)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Favoriten")
        }
    }
}

private struct FavoriteRow: View {
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pink.opacity(0.2))
                .frame(width: 90, height: 90)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundStyle(Color.pink)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text("Offline gespeichert")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
