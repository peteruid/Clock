import SwiftUI

struct FlipClockView: View {
    @ObservedObject var viewModel: ClockViewModel

    // Base layout dimensions (at 1x scale)
    private var baseWidth: CGFloat {
        // Each digit card: 54, colon: 16, spacing: 6 between items
        // HH:MM    = 4 digits + 1 colon = 54*4 + 16 + 6*4 = 256
        // HH:MM:SS = 6 digits + 2 colons = 54*6 + 16*2 + 6*7 = 398
        // + AM/PM  adds ~40
        let digits: CGFloat = viewModel.showSeconds ? 6 : 4
        let colons: CGFloat = viewModel.showSeconds ? 2 : 1
        let gaps = digits + colons - 1
        let amPmWidth: CGFloat = (!viewModel.is24Hour && viewModel.showAmPm) ? 36 : 0
        return digits * 54 + colons * 16 + gaps * 6 + amPmWidth
    }
    private let baseHeight: CGFloat = 81 // cardHalfHeight * 2 + 1pt gap

    var body: some View {
        GeometryReader { geo in
            let scale = min(geo.size.width / baseWidth, geo.size.height / baseHeight)

            HStack(spacing: 6) {
                // Hours
                FlipDigitView(digit: viewModel.hourTens, theme: viewModel.currentTheme)
                FlipDigitView(digit: viewModel.hourOnes, theme: viewModel.currentTheme)

                ColonView(theme: viewModel.currentTheme, blink: viewModel.blinkSeparators)

                // Minutes
                FlipDigitView(digit: viewModel.minuteTens, theme: viewModel.currentTheme)
                FlipDigitView(digit: viewModel.minuteOnes, theme: viewModel.currentTheme)

                if viewModel.showSeconds {
                    ColonView(theme: viewModel.currentTheme, blink: viewModel.blinkSeparators)

                    FlipDigitView(digit: viewModel.secondTens, theme: viewModel.currentTheme)
                    FlipDigitView(digit: viewModel.secondOnes, theme: viewModel.currentTheme)
                }

                if viewModel.showAmPm, let amPm = viewModel.amPm {
                    Text(amPm)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(viewModel.currentTheme.textColor.opacity(0.7))
                }
            }
            .opacity(viewModel.opacity)
            .scaleEffect(scale)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - Colon separator

private struct ColonView: View {
    let theme: Theme
    let blink: Bool
    @State private var visible = true

    var body: some View {
        VStack(spacing: 16) {
            Circle().frame(width: 7, height: 7)
            Circle().frame(width: 7, height: 7)
        }
        .foregroundStyle(theme.textColor)
        .opacity(visible ? 1.0 : 0.3)
        .onReceive(Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()) { _ in
            if blink {
                withAnimation(.easeInOut(duration: 0.15)) {
                    visible.toggle()
                }
            } else if !visible {
                visible = true
            }
        }
    }
}
