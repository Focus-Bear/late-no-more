//
//  MeetingReminderCountdown.swift
//  Late No More
//
//  Foundation only, so scripts/test-meeting-reminder-countdown.sh can compile and test it on its own.
//

import Foundation

/// The calendar's current view of the meeting occurrence a reminder is for.
struct MeetingReminderEvent: Equatable {
    let start: Date
    let end: Date
    let isCancelled: Bool
    let isDeclined: Bool

    var isCancelledOrDeclined: Bool { isCancelled || isDeclined }
}

enum MeetingReminderDismissReason: String, Equatable {
    case graceWindowElapsed = "grace window after the start elapsed"
    case meetingEnded = "meeting ended"
    case cancelled = "meeting was cancelled"
    case declined = "meeting was declined"
    case removedFromCalendar = "meeting is no longer in the calendar"
}

enum MeetingReminderPhase: Equatable {
    case startsIn(seconds: Int)
    case startedAgo(minutes: Int)
    case dismiss(MeetingReminderDismissReason)
}

enum MeetingReminderCountdown {
    /// Long enough to still pull in someone running a few minutes late; after that the reminder is noise
    /// that sits over whatever the person moved on to (it once stayed up for 7.6 hours).
    static let startedGraceSeconds: TimeInterval = 10 * 60
    static let secondsPerMinute = 60

    /// Derived from the wall clock on every call rather than a decremented counter, so a reminder that
    /// survives sleep or a stalled run loop still lands on the right phase when it next ticks.
    /// - Parameter event: `nil` when the occurrence can no longer be found in the calendar.
    static func phase(for event: MeetingReminderEvent?, now: Date) -> MeetingReminderPhase {
        guard let event = event else { return .dismiss(.removedFromCalendar) }
        if event.isCancelled { return .dismiss(.cancelled) }
        if event.isDeclined { return .dismiss(.declined) }

        let secondsUntilStart = event.start.timeIntervalSince(now)
        if secondsUntilStart > 0 {
            return .startsIn(seconds: Int(secondsUntilStart.rounded(.up)))
        }
        if hasEnded(event, now: now) { return .dismiss(.meetingEnded) }

        let secondsSinceStart = -secondsUntilStart
        if secondsSinceStart >= startedGraceSeconds { return .dismiss(.graceWindowElapsed) }
        return .startedAgo(minutes: Int(secondsSinceStart) / secondsPerMinute)
    }

    /// A zero-length event has no meaningful end, so only the grace window closes its reminder.
    private static func hasEnded(_ event: MeetingReminderEvent, now: Date) -> Bool {
        event.end > event.start && now >= event.end
    }

    /// `nil` for a phase that dismisses the reminder instead of showing a title.
    static func title(for phase: MeetingReminderPhase) -> String? {
        switch phase {
        case .startsIn(let seconds):
            return startsInTitle(seconds: seconds)
        case .startedAgo(let minutes):
            return startedAgoTitle(minutes: minutes)
        case .dismiss:
            return nil
        }
    }

    private static func startsInTitle(seconds totalSeconds: Int) -> String {
        let minutes = totalSeconds / secondsPerMinute
        let seconds = totalSeconds % secondsPerMinute
        let unit: String
        if minutes > 0 {
            unit = ReminderText.minutes
        } else {
            unit = seconds == 1 ? ReminderText.second : ReminderText.seconds
        }
        return String(format: ReminderText.startsInFormat, minutes, seconds, unit)
    }

    private static func startedAgoTitle(minutes: Int) -> String {
        switch minutes {
        case 0: return ReminderText.startedJustNow
        case 1: return ReminderText.startedOneMinuteAgo
        default: return String(format: ReminderText.startedMinutesAgoFormat, minutes)
        }
    }
}

private enum ReminderText {
    static let startsInFormat = "Your Meeting Starts in %d:%02d %@"
    static let minutes = "Minutes"
    static let seconds = "Seconds"
    static let second = "Second"
    static let startedJustNow = "Your Meeting Started Just Now"
    static let startedOneMinuteAgo = "Your Meeting Started 1 Minute Ago"
    static let startedMinutesAgoFormat = "Your Meeting Started %d Minutes Ago"
}
