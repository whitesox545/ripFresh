import SwiftUI

final class WeeklyPlanViewModel: ObservableObject {
    let days: [String] = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
    let plannedRecipes: [String] = [
        "Bunte Quinoa-Bowl",
        "Cremiges Pilzrisotto",
        "Halloumi-Auberginen-Burger",
        "Asiatische Nudelpfanne",
        "Scharfes Curry",
        "Mediterraner Orzo-Auflauf",
        "Süßkartoffel-Tacos"
    ]
}

struct WeeklyPlanView: View {
    @ObservedObject var viewModel: WeeklyPlanViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.days.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.days[index])
                            .font(.headline)
                        Text(viewModel.plannedRecipes[index])
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Wochenplanung")
        }
    }
}
