#!/bin/bash
# Unit tests for the end of swift-app/Late No More/EventWarningManager.swift (MeetingWarning, WarningTiming, FocusBearTrigger,
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
func due(_ timeUntilEvent: TimeInterval, sinceLastCheck: TimeInterval?, shown: Set<MeetingWarning> = []) -> [MeetingWarning] {
    WarningTiming.dueWarnings(timeUntilEvent: timeUntilEvent, secondsSinceLastCheck: sinceLastCheck, tolerance: tolerance,
                              alreadyShown: shown)
}

check(due(125, sinceLastCheck: 10) == [.twoMinutes], "on time, a few seconds early")
check(due(112, sinceLastCheck: 10) == [.twoMinutes], "on time, a few seconds late")
check(due(133, sinceLastCheck: 10).isEmpty, "not yet: 13 s before the moment")
// 21 Oct 2026: checks at 12:42:47 (133 s to go) and 12:44:47 (13 s to go) around a stall.
check(due(13, sinceLastCheck: 120) == [.twoMinutes], "a check after a stall still shows the missed join prompt")
// 27 Oct 2026: checks stalled 12:40:29-12:44:29 and that check's fetch ended at 12:45:08, 8 s after the start.
check(due(-8, sinceLastCheck: 279) == [.twoMinutes, .eventTime],
      "a stall past the start still shows the join prompt, then the start alert")
check(due(-180, sinceLastCheck: 3600) == [.twoMinutes, .eventTime], "waking 3 minutes into a meeting still shows its join prompt")
check(due(-(WarningTiming.missedTriggerGraceSeconds + 10), sinceLastCheck: 3600).isEmpty,
      "but not once the meeting is more than \(Int(WarningTiming.missedTriggerGraceSeconds / 60)) minutes in")
check(due(13, sinceLastCheck: nil).isEmpty, "the first check after launch shows only on-time warnings")
check(due(60, sinceLastCheck: 10).isEmpty, "a moment that passed before the previous check isn't shown again")
check(due(-8, sinceLastCheck: 279, shown: [.twoMinutes, .eventTime]).isEmpty, "each warning is shown once per meeting")
check(due(-15, sinceLastCheck: 10, shown: [.twoMinutes]) == [.eventTime], "a start alert that fell between two checks is caught up")
check(due(5, sinceLastCheck: 10) == [.twoMinutes, .eventTime],
      "a start with no join prompt yet (app launched after the two-minute moment) brings the prompt up")
check(due(5, sinceLastCheck: 10, shown: [.twoMinutes]) == [.eventTime], "a start after a closed join prompt doesn't reopen it")
check(due(100, sinceLastCheck: 900) == [.twoMinutes], "a stall over both moments shows the join prompt, not the 15-minute warning")
check(due(850, sinceLastCheck: 70) == [.fifteenMinutes], "a 15-minute warning missed in a short stall is caught up")
check(WarningTiming.pastEventCleanupSeconds > WarningTiming.missedTriggerGraceSeconds + tolerance,
      "a meeting's shown warnings outlive the catch-up window, so none can show twice")
check(WarningTiming.secondsLate(secondsSinceLastCheck: 279, checkInterval: tolerance) == 269, "a 269 s late check is logged")
check(WarningTiming.secondsLate(secondsSinceLastCheck: 35, checkInterval: tolerance) == nil, "a 25 s late check isn't")
check(WarningTiming.secondsLate(secondsSinceLastCheck: nil, checkInterval: tolerance) == nil, "the first check isn't late")

// Replay of 27 Oct 2026, 12:39-12:58, from LateNoMore_Logs.txt: when each check evaluated the meetings. The rule
// before this change (21 Oct catch-up: join prompt at most until the start) runs beside the new one.
func legacyIsDue(_ warning: MeetingWarning, timeUntilEvent: TimeInterval, secondsSinceLastCheck: TimeInterval?) -> Bool {
    let lateness = warning.secondsBeforeStart - timeUntilEvent
    let maximumLateness: TimeInterval = [.fifteenMinutes: 780, .twoMinutes: 120, .eventTime: 60][warning]!
    guard lateness >= -tolerance else { return false }
    if lateness <= tolerance { return true }
    guard let secondsSinceLastCheck else { return false }
    return lateness <= secondsSinceLastCheck + tolerance && lateness <= maximumLateness
}
let clock = DateFormatter()
clock.dateFormat = "HH:mm:ss"
clock.timeZone = TimeZone(identifier: "Australia/Melbourne")
func at(_ time: String) -> Date { ISO8601DateFormatter().date(from: "2026-10-27T\(time)+11:00")! }
let meetings = [("Data/AI standup", at("12:45:00")), ("UX checkin", at("13:00:00"))]
var checkTimes = ["12:39:28", "12:39:38", "12:39:48", "12:39:58", "12:40:08", "12:40:18", "12:40:29",
                  /* stalled until 12:44:29; that check's calendar fetch returned at */ "12:45:08"].map(at)
checkTimes += stride(from: 18.0, through: 918, by: 10).map { at("12:45:00").addingTimeInterval($0) }
func replay(isNewRule: Bool) -> [String: [MeetingWarning]] {
    var shown: [String: Set<MeetingWarning>] = [:]
    var shownAt: [String: [MeetingWarning]] = [:]
    var previousCheck: Date?
    print(isNewRule ? "-- new rule --" : "-- before (21 Oct catch-up) --")
    for checkTime in checkTimes {
        let since = previousCheck.map { checkTime.timeIntervalSince($0) }
        if let late = WarningTiming.secondsLate(secondsSinceLastCheck: since, checkInterval: tolerance) {
            print("\(clock.string(from: checkTime))  checkEvents ran \(Int(late)) s late")
        }
        for (title, start) in meetings {
            let timeUntil = start.timeIntervalSince(checkTime)
            let fired = isNewRule
                ? WarningTiming.dueWarnings(timeUntilEvent: timeUntil, secondsSinceLastCheck: since, tolerance: tolerance,
                                            alreadyShown: shown[title] ?? [])
                : MeetingWarning.allCases.filter { !(shown[title] ?? []).contains($0)
                    && legacyIsDue($0, timeUntilEvent: timeUntil, secondsSinceLastCheck: since) }
            for warning in fired {
                let late = warning.secondsBeforeStart - timeUntil
                let what = warning == .twoMinutes ? "join prompt + Focus Bear trigger" : warning == .eventTime ? "start alert" : "15-minute warning"
                print("\(clock.string(from: checkTime))  \(title): \(what)\(late > tolerance ? " (caught up \(Int(late)) s late)" : "")")
                shown[title, default: []].insert(warning)
                shownAt[title, default: []].append(warning)
            }
        }
        previousCheck = checkTime
    }
    return shownAt
}
let before = replay(isNewRule: false)
let after = replay(isNewRule: true)
check(before["Data/AI standup"] == [.eventTime], "replay: before, the 12:45 meeting got only a start alert with no prompt")
check(after["Data/AI standup"] == [.twoMinutes, .eventTime], "replay: now its join prompt and Focus Bear trigger fire at 12:45:08")
check(after["UX checkin"] == [.fifteenMinutes, .twoMinutes, .eventTime], "replay: the 1 pm meeting is unchanged")

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
