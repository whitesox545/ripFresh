import SwiftUI

final class CookingModeViewModel: ObservableObject {
    let recipeName: String
    let steps: [String]

    init(recipeName: String, steps: [String]) {
        self.recipeName = recipeName
        self.steps = steps
    }
}

struct CookingModeView: View {
    @ObservedObject var viewModel: CookingModeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(viewModel.recipeName)
                    .font(.largeTitle.weight(.bold))

                ForEach(viewModel.steps.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Schritt \(index + 1)")
                            .font(.title2.weight(.semibold))
                        Text(viewModel.steps[index])
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
            }
            .padding(20)
        }
        .navigationTitle("Kochmodus")
        .navigationBarTitleDisplayMode(.inline)
    }
}
