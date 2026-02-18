import SwiftUI

struct FlipDigitView: View {
    let digit: String
    let theme: Theme

    @State private var currentDigit = ""
    @State private var previousDigit = ""
    @State private var animateTop = false
    @State private var animateBottom = false

    var body: some View {
        VStack(spacing: 1) {
            // TOP HALF
            ZStack {
                // New value (static, behind)
                HalfCard(text: currentDigit, half: .top, theme: theme)
                // Old value (flips away)
                HalfCard(text: previousDigit, half: .top, theme: theme)
                    .rotation3DEffect(
                        .degrees(animateTop ? -90 : 0),
                        axis: (1, 0, 0),
                        anchor: .bottom,
                        perspective: 0.4
                    )
            }
            // BOTTOM HALF
            ZStack {
                // Old value (static, behind)
                HalfCard(text: previousDigit, half: .bottom, theme: theme)
                // New value (flips in)
                HalfCard(text: currentDigit, half: .bottom, theme: theme)
                    .rotation3DEffect(
                        .degrees(animateBottom ? 0 : 90),
                        axis: (1, 0, 0),
                        anchor: .top,
                        perspective: 0.4
                    )
            }
        }
        .onAppear {
            currentDigit = digit
            previousDigit = digit
        }
        .onChange(of: digit) { oldValue, newValue in
            previousDigit = oldValue
            animateTop = false
            animateBottom = false

            DispatchQueue.main.async {
                currentDigit = newValue
                withAnimation(.easeIn(duration: 0.2)) {
                    animateTop = true
                }
                withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
                    animateBottom = true
                }
            }
        }
    }
}

// MARK: - Half Card

private enum HalfPosition {
    case top, bottom
}

private struct HalfCard: View {
    let text: String
    let half: HalfPosition
    let theme: Theme

    private let cardWidth: CGFloat = 54
    private let cardFullHeight: CGFloat = 80
    private var cardHalfHeight: CGFloat { cardFullHeight / 2 }
    private let cornerRadius: CGFloat = 8
    private let fontSize: CGFloat = 64

    var body: some View {
        ZStack {
            // Card background
            UnevenRoundedRectangle(
                topLeadingRadius: half == .top ? cornerRadius : 0,
                bottomLeadingRadius: half == .bottom ? cornerRadius : 0,
                bottomTrailingRadius: half == .bottom ? cornerRadius : 0,
                topTrailingRadius: half == .top ? cornerRadius : 0
            )
            .fill(theme.cardColor)
            .overlay(
                // Subtle gradient for depth
                LinearGradient(
                    colors: half == .top
                        ? [.white.opacity(0.06), .clear]
                        : [.clear, .white.opacity(0.03)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // Digit text, clipped to show only the correct half
            Text(text)
                .font(.system(size: fontSize, weight: .heavy, design: .rounded))
                .foregroundStyle(theme.textColor)
                .frame(width: cardWidth, height: cardFullHeight)
                .offset(y: half == .top ? cardHalfHeight / 2 : -cardHalfHeight / 2)
        }
        .frame(width: cardWidth, height: cardHalfHeight)
        .clipped()
    }
}
