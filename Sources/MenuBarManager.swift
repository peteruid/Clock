import AppKit
import Combine

@MainActor
final class MenuBarManager: NSObject, NSMenuDelegate {
    private var statusItem: NSStatusItem
    private let viewModel: ClockViewModel
    private weak var panel: ClockPanel?
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ClockViewModel, panel: ClockPanel) {
        self.viewModel = viewModel
        self.panel = panel
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        super.init()

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clock.fill", accessibilityDescription: "Flip Clock")
            button.image?.size = NSSize(width: 18, height: 18)
            button.image?.isTemplate = true
        }

        let menu = NSMenu()
        menu.delegate = self
        statusItem.menu = menu
    }

    func menuWillOpen(_ menu: NSMenu) {
        panel?.bringToFront()
    }

    // Rebuild menu every time it opens to sync checkmarks
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        // Window Level
        for wl in WindowLevel.allCases {
            let item = NSMenuItem(title: wl.label, action: #selector(setWindowLevel(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = wl.rawValue
            item.state = viewModel.windowLevel == wl ? .on : .off
            menu.addItem(item)
        }

        menu.addItem(.separator())

        // Time format
        let fmt12 = NSMenuItem(title: "12-Hour", action: #selector(set12Hour), keyEquivalent: "")
        fmt12.target = self
        fmt12.state = viewModel.is24Hour ? .off : .on
        menu.addItem(fmt12)

        let fmt24 = NSMenuItem(title: "24-Hour", action: #selector(set24Hour), keyEquivalent: "")
        fmt24.target = self
        fmt24.state = viewModel.is24Hour ? .on : .off
        menu.addItem(fmt24)

        if !viewModel.is24Hour {
            let ampm = NSMenuItem(title: "Show AM/PM", action: #selector(toggleAmPm), keyEquivalent: "")
            ampm.target = self
            ampm.state = viewModel.showAmPm ? .on : .off
            menu.addItem(ampm)
        }

        menu.addItem(.separator())

        // Show Seconds
        let sec = NSMenuItem(title: "Show Seconds", action: #selector(toggleSeconds), keyEquivalent: "")
        sec.target = self
        sec.state = viewModel.showSeconds ? .on : .off
        menu.addItem(sec)

        // Blink Separators
        let blink = NSMenuItem(title: "Blink Separators", action: #selector(toggleBlink), keyEquivalent: "")
        blink.target = self
        blink.state = viewModel.blinkSeparators ? .on : .off
        menu.addItem(blink)

        menu.addItem(.separator())

        // Opacity submenu
        let opacityItem = NSMenuItem(title: "Opacity", action: nil, keyEquivalent: "")
        let opacityMenu = NSMenu()
        for pct in [25, 50, 75, 100] {
            let val = Double(pct) / 100.0
            let item = NSMenuItem(title: "\(pct)%", action: #selector(setOpacity(_:)), keyEquivalent: "")
            item.target = self
            item.tag = pct
            item.state = abs(viewModel.opacity - val) < 0.01 ? .on : .off
            opacityMenu.addItem(item)
        }
        opacityItem.submenu = opacityMenu
        menu.addItem(opacityItem)

        // Theme submenu
        let themeItem = NSMenuItem(title: "Theme", action: nil, keyEquivalent: "")
        let themeMenu = NSMenu()
        for theme in Theme.all {
            let item = NSMenuItem(title: theme.name, action: #selector(selectTheme(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = theme.id
            item.state = viewModel.currentTheme.id == theme.id ? .on : .off
            themeMenu.addItem(item)
        }
        themeItem.submenu = themeMenu
        menu.addItem(themeItem)

        menu.addItem(.separator())

        // Quit
        let quit = NSMenuItem(title: "Quit Flip Clock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)
    }

    // MARK: - Actions

    @objc private func setWindowLevel(_ sender: NSMenuItem) {
        guard let raw = sender.representedObject as? String,
              let wl = WindowLevel(rawValue: raw) else { return }
        viewModel.windowLevel = wl
        panel?.updateWindowLevel(wl)
    }

    @objc private func set12Hour() {
        viewModel.is24Hour = false
    }

    @objc private func set24Hour() {
        viewModel.is24Hour = true
    }

    @objc private func toggleSeconds() {
        viewModel.showSeconds.toggle()
        panel?.updateAspectRatio(showSeconds: viewModel.showSeconds)
    }

    @objc private func toggleAmPm() {
        viewModel.showAmPm.toggle()
    }

    @objc private func toggleBlink() {
        viewModel.blinkSeparators.toggle()
    }

    @objc private func setOpacity(_ sender: NSMenuItem) {
        viewModel.opacity = Double(sender.tag) / 100.0
    }

    @objc private func selectTheme(_ sender: NSMenuItem) {
        guard let themeId = sender.representedObject as? String else { return }
        viewModel.currentTheme = Theme.named(themeId)
    }
}
