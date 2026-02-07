import SwiftUI

enum AppTheme {
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let accent = Color.calmBlue
    static let secondaryText = Color.secondary
    static let divider = Color(.separator)

    static let cornerRadius: CGFloat = 20
    static let cardCornerRadius: CGFloat = 26
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16

    static func titleFont() -> Font {
        .system(.title, design: .rounded).weight(.bold)
    }

    static func subtitleFont() -> Font {
        .system(.headline, design: .rounded).weight(.semibold)
    }

    static func bodyFont() -> Font {
        .system(.body, design: .rounded)
    }

    static func captionFont() -> Font {
        .system(.caption, design: .rounded)
    }
}

extension Color {
    static let calmBlue = Color(red: 0.18, green: 0.24, blue: 0.35)
    static let calmMint = Color(red: 0.42, green: 0.65, blue: 0.58)
    static let calmSand = Color(red: 0.94, green: 0.91, blue: 0.86)
    static let calmStone = Color(red: 0.62, green: 0.63, blue: 0.64)
}

struct CalmCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func calmCard() -> some View {
        modifier(CalmCardStyle())
    }
}
