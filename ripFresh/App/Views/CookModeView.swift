import SwiftUI

struct CookModeView: View {
    @StateObject var viewModel: CookModeViewModel

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.recipe.title)
                    .font(AppTheme.subtitleFont())
                Text(viewModel.progressText)
                    .font(AppTheme.captionFont())
                    .foregroundColor(AppTheme.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewModel.currentStep.title)
                .font(AppTheme.titleFont())
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewModel.currentStep.instructions)
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                Label("\(viewModel.currentStep.durationMinutes) Min", systemImage: "timer")
                Label("Hände frei", systemImage: "hand.raised")
            }
            .font(AppTheme.captionFont())
            .foregroundColor(AppTheme.secondaryText)

            Toggle("Display wach halten", isOn: $viewModel.keepScreenAwake)
                .font(AppTheme.bodyFont())
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Spacer()

            HStack(spacing: 12) {
                Button(action: viewModel.goToPrevious) {
                    Text("Zurück")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: viewModel.goToNext) {
                    Text("Weiter")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(AppTheme.horizontalPadding)
        .navigationTitle("Kochmodus")
        .navigationBarTitleDisplayMode(.inline)
    }
}
