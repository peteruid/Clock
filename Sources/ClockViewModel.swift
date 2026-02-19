import SwiftUI
import Combine

enum WindowLevel: String, CaseIterable {
    case floating = "floating"
    case normal = "normal"
    case desktop = "desktop"

    var label: String {
        switch self {
        case .floating: "Keep on Top"
        case .normal: "Normal"
        case .desktop: "Keep on Desktop"
        }
    }
}

final class ClockViewModel: ObservableObject {
    // Individual digit strings for animation
    @Published var hourTens = ""
    @Published var hourOnes = ""
    @Published var minuteTens = ""
    @Published var minuteOnes = ""
    @Published var secondTens = ""
    @Published var secondOnes = ""
    @Published var amPm: String? = nil

    // Settings
    @Published var is24Hour: Bool {
        didSet { UserDefaults.standard.set(is24Hour, forKey: "is24Hour") }
    }
    @Published var showSeconds: Bool {
        didSet { UserDefaults.standard.set(showSeconds, forKey: "showSeconds") }
    }
    @Published var currentTheme: Theme {
        didSet { UserDefaults.standard.set(currentTheme.id, forKey: "themeId") }
    }
    @Published var windowLevel: WindowLevel {
        didSet { UserDefaults.standard.set(windowLevel.rawValue, forKey: "windowLevel") }
    }
    @Published var blinkSeparators: Bool {
        didSet { UserDefaults.standard.set(blinkSeparators, forKey: "blinkSeparators") }
    }
    @Published var showAmPm: Bool {
        didSet { UserDefaults.standard.set(showAmPm, forKey: "showAmPm") }
    }
    @Published var opacity: Double {
        didSet { UserDefaults.standard.set(opacity, forKey: "opacity") }
    }
    @Published var showOnAllSpaces: Bool {
        didSet { UserDefaults.standard.set(showOnAllSpaces, forKey: "showOnAllSpaces") }
    }

    private var timer: AnyCancellable?

    init() {
        let defaults = UserDefaults.standard
        self.is24Hour = defaults.object(forKey: "is24Hour") as? Bool ?? false
        self.showSeconds = defaults.object(forKey: "showSeconds") as? Bool ?? true
        self.currentTheme = Theme.named(defaults.string(forKey: "themeId") ?? "classic")
        self.windowLevel = WindowLevel(rawValue: defaults.string(forKey: "windowLevel") ?? "") ?? .floating
        self.blinkSeparators = defaults.object(forKey: "blinkSeparators") as? Bool ?? true
        self.showAmPm = defaults.object(forKey: "showAmPm") as? Bool ?? true
        self.opacity = defaults.object(forKey: "opacity") as? Double ?? 1.0
        self.showOnAllSpaces = defaults.object(forKey: "showOnAllSpaces") as? Bool ?? true

        updateDigits()
        startTimer()
    }

    private func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.updateDigits() }
    }

    private func updateDigits() {
        let now = Date()
        let cal = Calendar.current
        var hour = cal.component(.hour, from: now)
        let minute = cal.component(.minute, from: now)
        let second = cal.component(.second, from: now)

        if !is24Hour {
            amPm = hour >= 12 ? "PM" : "AM"
            hour = hour % 12
            if hour == 0 { hour = 12 }
        } else {
            amPm = nil
        }

        let h = String(format: "%02d", hour)
        let m = String(format: "%02d", minute)
        let s = String(format: "%02d", second)

        let newHT = String(h[h.startIndex])
        let newHO = String(h[h.index(after: h.startIndex)])
        let newMT = String(m[m.startIndex])
        let newMO = String(m[m.index(after: m.startIndex)])
        let newST = String(s[s.startIndex])
        let newSO = String(s[s.index(after: s.startIndex)])

        if newHT != hourTens   { hourTens = newHT }
        if newHO != hourOnes   { hourOnes = newHO }
        if newMT != minuteTens { minuteTens = newMT }
        if newMO != minuteOnes { minuteOnes = newMO }
        if newST != secondTens { secondTens = newST }
        if newSO != secondOnes { secondOnes = newSO }
    }
}
