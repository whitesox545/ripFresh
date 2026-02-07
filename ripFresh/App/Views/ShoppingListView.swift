import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel: ShoppingListViewModel

    var body: some View {
        VStack(spacing: 16) {
            header

            HStack {
                TextField("Neuer Eintrag", text: $viewModel.manualEntry)
                    .textFieldStyle(.roundedBorder)
                Button("Hinzufügen") {
                    viewModel.addManual()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, AppTheme.horizontalPadding)

            List {
                ForEach(viewModel.items) { item in
                    HStack {
                        Button(action: { viewModel.toggle(item) }) {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isChecked ? .green : AppTheme.secondaryText)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(AppTheme.bodyFont())
                            Text("\(item.displayQuantity) · \(item.category)")
                                .font(AppTheme.captionFont())
                                .foregroundColor(AppTheme.secondaryText)
                        }
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Einkaufsliste")
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Alles auf einen Blick")
                .font(AppTheme.titleFont())
            Text("Offline verfügbar, damit du im Laden keine Verbindung brauchst.")
                .font(AppTheme.bodyFont())
                .foregroundColor(AppTheme.secondaryText)
        }
        .padding(.horizontal, AppTheme.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
