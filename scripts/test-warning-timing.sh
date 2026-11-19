#!/bin/bash
# Unit tests for the end of swift-app/Late No More/EventWarningManager.swift (WarningTiming, FocusBearTrigger,
# AlertWindowPresentation): compiles that part on its own with swiftc and runs the cases below. No Xcode
# project or test target needed. The window cases open a transparent window for a moment.
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_file="$repo_root/swift-app/Late No More/EventWarningManager.swift"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

{ echo "import AppKit"; sed -n '/^\/\/ MARK: - WarningTiming/,$p' "$source_file"; } > "$work_dir/WarningTiming.swift"
cat > "$work_dir/main.swift" <<'SWIFT'
import AppKit

func addLog(text: String) {}

var failures = 0
func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failures += 1 }
}

let tolerance: TimeInterval = 10
let twoMinutes: TimeInterval = 120
func twoMinuteWarningIsDue(timeUntilEvent: TimeInterval, sinceLastCheck: TimeInterval?) -> Bool {
    WarningTiming.isDue(timeUntilEvent: timeUntilEvent, warningInterval: twoMinutes, secondsSinceLastCheck: sinceLastCheck,
                        tolerance: tolerance, maximumLateness: twoMinutes)
}

check(twoMinuteWarningIsDue(timeUntilEvent: 125, sinceLastCheck: 10), "on time, a few seconds early")
check(twoMinuteWarningIsDue(timeUntilEvent: 112, sinceLastCheck: 10), "on time, a few seconds late")
check(!twoMinuteWarningIsDue(timeUntilEvent: 133, sinceLastCheck: 10), "not yet: 13 s before the moment")
// 21 Oct 2026: checks at 12:42:47 (133 s to go) and 12:44:47 (13 s to go) around a stall.
check(twoMinuteWarningIsDue(timeUntilEvent: 13, sinceLastCheck: 120), "a check after a stall still shows the missed warning")
check(!twoMinuteWarningIsDue(timeUntilEvent: 13, sinceLastCheck: nil), "the first check after launch shows only on-time warnings")
check(!twoMinuteWarningIsDue(timeUntilEvent: 60, sinceLastCheck: 10), "a moment that passed before the previous check isn't shown again")
check(!twoMinuteWarningIsDue(timeUntilEvent: -5, sinceLastCheck: 3600), "never after the meeting has started, even after a long sleep")
check(WarningTiming.isDue(timeUntilEvent: -30, warningInterval: 0, secondsSinceLastCheck: 45, tolerance: tolerance,
                          maximumLateness: WarningTiming.pastEventCleanupSeconds), "the start alert is shown up to a minute late")
check(!WarningTiming.isDue(timeUntilEvent: -90, warningInterval: 0, secondsSinceLastCheck: 120, tolerance: tolerance,
                           maximumLateness: WarningTiming.pastEventCleanupSeconds), "but not once the event is cleaned up")

// Focus Bear trigger: the same link as before, but opening it must not hand Focus Bear the focus.
let isoFormatter = ISO8601DateFormatter()
let pactStart = isoFormatter.date(from: "2026-10-21T05:45:00Z")!
let pactEnd = isoFormatter.date(from: "2026-10-21T06:00:00Z")!
check(FocusBearTrigger.eventAboutToStartURL(title: "Group test of PACT (classroom mode)", start: pactStart, end: pactEnd)?.absoluteString
      == "focusbear://event-about-to-start?event_title=Group%20test%20of%20PACT%20(classroom%20mode)&event_start_time=2026-10-21T05:45:00Z&event_end_time=2026-10-21T06:00:00Z",
      "the Focus Bear link is unchanged (21 Oct 2026, 4:45 pm meeting)")
check(!FocusBearTrigger.openConfiguration.activates, "triggering Focus Bear doesn't make it the active app")

// Alert windows, from a process that is never the active app, as Late No More isn't when an alert fires.
let application = NSApplication.shared
application.setActivationPolicy(.accessory)
func makeAlertWindowController() -> NSWindowController {
    let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
    window.alphaValue = 0
    return NSWindowController(window: window)
}
let alertWindowController = makeAlertWindowController()
AlertWindowPresentation.present(alertWindowController)
let alertWindow = alertWindowController.window!
check(!application.isActive, "the test process isn't the active app")
check(alertWindow.isVisible, "an alert is on screen although its app isn't active")
check(alertWindow.level == AlertWindowPresentation.level, "an alert sits at the modal panel level")
check(alertWindow.collectionBehavior.contains(.canJoinAllSpaces) && alertWindow.collectionBehavior.contains(.fullScreenAuxiliary),
      "an alert shows on the Space the user is on, also over a full-screen app")
alertWindow.orderOut(nil)
AlertWindowPresentation.bringToFront(alertWindow)
check(alertWindow.isVisible, "bringing an alert forward at the meeting's start puts it back on screen")
alertWindow.orderOut(nil)

if failures > 0 { print("\(failures) failed"); exit(1) }
print("all passed")
SWIFT
xcrun swiftc "$work_dir/WarningTiming.swift" "$work_dir/main.swift" -o "$work_dir/test-warning-timing"
"$work_dir/test-warning-timing"
