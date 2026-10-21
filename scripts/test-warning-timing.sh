#!/bin/bash
# Unit tests for WarningTiming (swift-app/Late No More/EventWarningManager.swift): compiles that enum on
# its own with swiftc and runs the cases below. No Xcode project or test target needed.
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_file="$repo_root/swift-app/Late No More/EventWarningManager.swift"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

{ echo "import Foundation"; sed -n '/^\/\/ MARK: - WarningTiming/,$p' "$source_file"; } > "$work_dir/WarningTiming.swift"
cat > "$work_dir/main.swift" <<'SWIFT'
import Foundation

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

if failures > 0 { print("\(failures) failed"); exit(1) }
print("all passed")
SWIFT
xcrun swiftc "$work_dir/WarningTiming.swift" "$work_dir/main.swift" -o "$work_dir/test-warning-timing"
"$work_dir/test-warning-timing"
