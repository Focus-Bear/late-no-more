import Foundation

private var failures = 0

private func expect<T: Equatable>(_ actual: T, _ expected: T, _ name: String) {
    if actual == expected {
        print("PASS \(name)")
    } else {
        failures += 1
        print("FAIL \(name): expected \(expected), got \(actual)")
    }
}

// Fixed clock: the stand-up from the bug report, Sunday 8 November 2026, 1:00–1:15 pm.
private let meetingStart = Date(timeIntervalSince1970: 1_794_103_200)
private let meetingLengthSeconds: TimeInterval = 15 * 60
private let standUp = MeetingReminderEvent(start: meetingStart,
                                           end: meetingStart.addingTimeInterval(meetingLengthSeconds),
                                           isCancelled: false,
                                           isDeclined: false)
private let grace = MeetingReminderCountdown.startedGraceSeconds

private func at(_ secondsFromStart: TimeInterval) -> Date {
    meetingStart.addingTimeInterval(secondsFromStart)
}

private func phase(_ event: MeetingReminderEvent?, _ secondsFromStart: TimeInterval) -> MeetingReminderPhase {
    MeetingReminderCountdown.phase(for: event, now: at(secondsFromStart))
}

private func titleAt(_ secondsFromStart: TimeInterval) -> String? {
    MeetingReminderCountdown.title(for: phase(standUp, secondsFromStart))
}

private func withTimes(start: Date, end: Date) -> MeetingReminderEvent {
    MeetingReminderEvent(start: start, end: end, isCancelled: false, isDeclined: false)
}

// Before the start: counts down from the two-minute warning.
expect(phase(standUp, -120), .startsIn(seconds: 120), "two minutes before")
expect(titleAt(-120), "Your Meeting Starts in 2:00 Minutes", "two-minute title")
expect(titleAt(-61.5), "Your Meeting Starts in 1:02 Minutes", "partial seconds round up")
expect(titleAt(-30), "Your Meeting Starts in 0:30 Seconds", "under a minute")
expect(titleAt(-1), "Your Meeting Starts in 0:01 Second", "one second")
expect(titleAt(-0.2), "Your Meeting Starts in 0:01 Second", "never shows 0:00 before the start")

// After the start: started-ago, never a negative countdown.
expect(phase(standUp, 0), .startedAgo(minutes: 0), "at the start")
expect(titleAt(0), "Your Meeting Started Just Now", "just started title")
expect(titleAt(59), "Your Meeting Started Just Now", "under a minute after")
expect(titleAt(60), "Your Meeting Started 1 Minute Ago", "one minute after")
expect(titleAt(9 * 60 + 59), "Your Meeting Started 9 Minutes Ago", "just inside the grace window")

// Grace window over: dismissed.
expect(phase(standUp, grace), .dismiss(.graceWindowElapsed), "grace window elapsed")
expect(titleAt(grace), nil, "no title once dismissed")

// The bug report: still up 7 h 39 min after a 1:00 pm meeting.
let bugReportSecondsAfterStart: TimeInterval = (7 * 60 + 39) * 60 + 21
expect(phase(standUp, bugReportSecondsAfterStart), .dismiss(.meetingEnded), "bug report: hours after the meeting")
for secondsAfterStart in stride(from: 0.0, through: bugReportSecondsAfterStart, by: 37) {
    if let title = titleAt(secondsAfterStart), title.contains("-") {
        expect(title, "no negative countdown", "negative countdown at +\(secondsAfterStart)s")
    }
}

// A meeting shorter than the grace window is dismissed when it ends.
let fiveMinuteMeeting = withTimes(start: meetingStart, end: at(5 * 60))
expect(phase(fiveMinuteMeeting, 4 * 60), .startedAgo(minutes: 4), "short meeting still running")
expect(phase(fiveMinuteMeeting, 5 * 60), .dismiss(.meetingEnded), "short meeting ended")

// A zero-length event has no real end, so only the grace window applies.
let zeroLengthEvent = withTimes(start: meetingStart, end: meetingStart)
expect(phase(zeroLengthEvent, 60), .startedAgo(minutes: 1), "zero-length event keeps its grace window")
expect(phase(zeroLengthEvent, grace), .dismiss(.graceWindowElapsed), "zero-length event dismissed after grace")

// Calendar changes made while the reminder is up dismiss it immediately, even before the start.
let cancelled = MeetingReminderEvent(start: standUp.start, end: standUp.end, isCancelled: true, isDeclined: false)
let declined = MeetingReminderEvent(start: standUp.start, end: standUp.end, isCancelled: false, isDeclined: true)
expect(phase(cancelled, -90), .dismiss(.cancelled), "cancelled before the start")
expect(phase(declined, -90), .dismiss(.declined), "declined before the start")
expect(phase(nil, -90), .dismiss(.removedFromCalendar), "deleted from the calendar")
expect(cancelled.isCancelledOrDeclined, true, "cancelled is skipped by the warning check")
expect(declined.isCancelledOrDeclined, true, "declined is skipped by the warning check")
expect(standUp.isCancelledOrDeclined, false, "accepted meeting still warns")

// Moved five minutes later: the countdown follows the new start.
let movedLater = withTimes(start: at(5 * 60), end: at(5 * 60 + meetingLengthSeconds))
expect(phase(movedLater, 0), .startsIn(seconds: 300), "rescheduled meeting counts down to its new start")

if failures > 0 {
    print("\(failures) failure(s)")
    exit(1)
}
print("All meeting reminder countdown tests passed")
