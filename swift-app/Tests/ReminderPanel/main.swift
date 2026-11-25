//
//  main.swift
//  ReminderPanel tests
//
//  The 15-minute reminder (warnUserVc.swift). The app has no test target, so
//  scripts/test-reminder-panel.sh compiles this with that one file and runs it.
//

import Cocoa

/// globalFile.swift's Button, which would pull in the whole app.
class Button: NSButton {}

private var failures: [String] = []

private func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failures.append(name) }
}

// Keeps the test windows off the user's screen while they are ordered in.
private let OFFSCREEN_FRAME = NSRect(x: -20_000, y: -20_000, width: 480, height: 270)

private func offscreenWindow(_ window: NSWindow) -> NSWindow {
    window.setFrame(OFFSCREEN_FRAME, display: false)
    window.alphaValue = 0
    return window
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

// MARK: The panel

let panel = ReminderPanel.make()
check(panel.styleMask.contains(.nonactivatingPanel), "clicking the reminder does not activate Late No More")
check(panel.becomesKeyOnlyIfNeeded, "clicking the reminder's button does not make it key")
check(!panel.hidesOnDeactivate, "the reminder stays visible while Late No More is in the background")
check(panel.level == .modalPanel, "the reminder floats above other apps' windows")
check(!panel.isReleasedWhenClosed, "the reminder can be shown again after it is dismissed")
check(ReminderButton().acceptsFirstMouse(for: nil), "the first click on Got it dismisses the reminder")

// MARK: Got it

// The settings window showMainWindow() opens at launch and the user left open behind other apps.
let settingsWindow = offscreenWindow(NSWindow(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false))
settingsWindow.orderBack(nil)

let reminder = warnUserVc()
reminder.view = NSView()
let reminderPanel = offscreenWindow(ReminderPanel.make())
reminderPanel.contentViewController = reminder
ReminderPanel.show(reminderPanel)
check(reminderPanel.isVisible, "the reminder is shown")
check(!reminderPanel.isKeyWindow, "showing the reminder does not take the keyboard")

reminder.btnGotItClicked(reminder)
check(!reminderPanel.isVisible, "Got it dismisses the reminder")
check(!app.isActive, "Got it does not activate Late No More")
check(!settingsWindow.isKeyWindow && app.keyWindow == nil, "Got it does not hand the keyboard to the settings window")

settingsWindow.close()

if failures.isEmpty {
    print("All reminder panel tests passed")
} else {
    print("\(failures.count) failed: \(failures.joined(separator: ", "))")
    exit(1)
}
