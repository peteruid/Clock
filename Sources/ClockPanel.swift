import AppKit
import SwiftUI

class ClockPanel: NSPanel {
    init(viewModel: ClockViewModel) {
        // .nonactivatingPanel = rawValue 128, allows panel to not steal focus
        let nonActivating = NSWindow.StyleMask(rawValue: 1 << 7)
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 120),
            styleMask: [nonActivating, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        isMovableByWindowBackground = true
        isFloatingPanel = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        becomesKeyOnlyIfNeeded = true

        contentAspectRatio = NSSize(width: 500, height: 120)
        minSize = NSSize(width: 250, height: 60)
        maxSize = NSSize(width: 1500, height: 360)

        let hostingView = NSHostingView(
            rootView: FlipClockView(viewModel: viewModel)
                .ignoresSafeArea()
        )
        hostingView.wantsLayer = true
        hostingView.layer?.isOpaque = false
        contentView = hostingView

        // Restore saved position and size
        if let data = UserDefaults.standard.string(forKey: "windowFrame") {
            let parts = data.split(separator: ",").compactMap { Double($0) }
            if parts.count == 4 {
                let restored = NSRect(x: parts[0], y: parts[1], width: parts[2], height: parts[3])
                setFrame(restored, display: false)
            }
        }

        NotificationCenter.default.addObserver(
            self, selector: #selector(persistFrame),
            name: NSWindow.didMoveNotification, object: self
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(persistFrame),
            name: NSWindow.didResizeNotification, object: self
        )
    }

    @objc private func persistFrame() {
        let f = frame
        let str = "\(f.origin.x),\(f.origin.y),\(f.size.width),\(f.size.height)"
        UserDefaults.standard.set(str, forKey: "windowFrame")
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    func ensureOnScreen() {
        guard let screen = NSScreen.screens.first(where: { $0.frame.intersects(frame) }) ?? NSScreen.main else {
            center()
            return
        }
        let visible = screen.visibleFrame
        var f = frame
        // Nudge into visible area if needed
        if f.maxX < visible.minX + 20 { f.origin.x = visible.minX }
        if f.minX > visible.maxX - 20 { f.origin.x = visible.maxX - f.width }
        if f.maxY < visible.minY + 20 { f.origin.y = visible.minY }
        if f.minY > visible.maxY - 20 { f.origin.y = visible.maxY - f.height }
        setFrame(f, display: true)
    }

    private var currentWindowLevel: WindowLevel = .floating

    func bringToFront() {
        ensureOnScreen()
        if currentWindowLevel == .desktop {
            // For desktop mode, temporarily pop to floating so it's visible
            level = .floating
            orderFrontRegardless()
            // Settle back to desktop after a few seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self, self.currentWindowLevel == .desktop else { return }
                self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
            }
        } else {
            // For normal/floating, just order front
            let savedLevel = level
            level = .floating
            orderFrontRegardless()
            if currentWindowLevel == .normal {
                level = savedLevel
            }
        }
    }

    func updateWindowLevel(_ wl: WindowLevel) {
        currentWindowLevel = wl
        switch wl {
        case .floating:
            level = .floating
            isFloatingPanel = true
            collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            ignoresMouseEvents = false
        case .normal:
            level = .normal
            isFloatingPanel = false
            collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            ignoresMouseEvents = false
        case .desktop:
            level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
            isFloatingPanel = false
            collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
            ignoresMouseEvents = false
        }
    }

    func updateAspectRatio(showSeconds: Bool) {
        contentAspectRatio = showSeconds
            ? NSSize(width: 500, height: 120)
            : NSSize(width: 360, height: 120)
    }
}
