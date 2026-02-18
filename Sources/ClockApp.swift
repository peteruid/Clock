import SwiftUI
import AppKit

@main
struct ClockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: ClockPanel!
    private var menuBarManager: MenuBarManager!
    private var viewModel: ClockViewModel!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        viewModel = ClockViewModel()

        panel = ClockPanel(viewModel: viewModel)
        panel.updateWindowLevel(viewModel.windowLevel)
        // Only center if no saved position (first launch)
        if UserDefaults.standard.string(forKey: "windowFrame") == nil {
            panel.center()
        }
        panel.ensureOnScreen()
        panel.orderFront(nil)

        menuBarManager = MenuBarManager(viewModel: viewModel, panel: panel)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
