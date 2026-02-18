import SwiftUI
import AppKit

private let singleInstanceNotification = "com.flipclock.bringToFront"

@main
struct ClockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: ClockPanel!
    private var menuBarManager: MenuBarManager!
    private var viewModel: ClockViewModel!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Single-instance check: if another instance is already running, tell it
        // to come to front and quit this new instance immediately.
        let runningInstances = NSRunningApplication.runningApplications(
            withBundleIdentifier: Bundle.main.bundleIdentifier ?? "com.flipclock.Clock"
        ).filter { $0 != NSRunningApplication.current }

        if !runningInstances.isEmpty {
            // Tell the existing instance to bring itself to front
            DistributedNotificationCenter.default().postNotificationName(
                NSNotification.Name(singleInstanceNotification),
                object: nil,
                userInfo: nil,
                deliverImmediately: true
            )
            // Give the notification a moment to deliver, then quit
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                NSApp.terminate(nil)
            }
            return
        }

        // Listen for bring-to-front requests from future launch attempts
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleBringToFront),
            name: NSNotification.Name(singleInstanceNotification),
            object: nil
        )

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

    @objc private func handleBringToFront(_ notification: Notification) {
        panel?.bringToFront()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
