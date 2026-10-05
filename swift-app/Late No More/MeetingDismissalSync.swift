//
//  MeetingDismissalSync.swift
//  Late No More
//
//  Cross-device meeting-dismissal sync, Late No More's half of it.
//
//  Late No More has no account and never talks to the Focus Bear backend. The Focus Bear Mac app
//  does: it reports a dismissal to the backend, and it hears the backend's
//  `late-no-more-event-dismissed` broadcast when the user deals with the same meeting on their phone
//  or Windows PC (backend#2395). The two apps talk over distributed notifications, so neither has to
//  be frontmost, and neither launches the other. If Focus Bear isn't running, nothing is sent or
//  heard, and Late No More alerts exactly as it always has.
//
//  Meetings are matched by title + start time. That's the only identity every platform agrees on:
//  EventKit, the phone's calendar and the backend each give the same meeting a different id.
//

import Cocoa

/// Wire contract with the Focus Bear Mac app (`LateNoMoreBridgeContract` in `LateNoMoreDismissSync.swift`
/// there). The two copies must keep these values identical. Rename only the code references.
enum FocusBearDismissalBridge {
    /// Focus Bear → Late No More: the meeting was dealt with on another device, so stop alerting for it.
    static let dismissedElsewhereNotification = Notification.Name("io.focusbear.late-no-more.meeting-dismissed-elsewhere")
    /// Late No More → Focus Bear: the user dealt with the meeting here, so tell their other devices.
    static let acknowledgedNotification = Notification.Name("io.focusbear.late-no-more.meeting-acknowledged")

    static let eventTitleKey = "event_title"
    /// ISO-8601, same format as the `event_start_time` of the `focusbear://event-about-to-start` link.
    static let eventBeginsKey = "event_begins"
    static let dismissReasonKey = "dismiss_reason"

    /// Devices round a meeting's start instant differently, so starts this close are the same meeting.
    /// Same window as the backend and the other clients.
    static let startMatchToleranceSeconds: TimeInterval = 60
}

/// Why the user stopped a reminder here. The values are the backend's `dismiss_reason` vocabulary.
enum MeetingDismissReason: String {
    /// "I don't need to attend": every device should stop reminding them.
    case stopReminders = "stop_reminders"
    /// Joined from the alert: the meeting is handled, so the phone no longer needs to nag.
    case joinedOnMac = "joined_on_mac"
}

/// One meeting, reduced to the fields that survive crossing devices.
struct MeetingIdentity: Equatable {
    let title: String
    let startDate: Date

    /// Titles equal once trimmed and case-folded, and starts within the shared tolerance.
    func isSameMeeting(as other: MeetingIdentity) -> Bool {
        let normalisedTitle = Self.normalise(title)
        guard !normalisedTitle.isEmpty, normalisedTitle == Self.normalise(other.title) else { return false }
        return abs(startDate.timeIntervalSince(other.startDate)) <= FocusBearDismissalBridge.startMatchToleranceSeconds
    }

    private static func normalise(_ title: String) -> String {
        title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

/// Meetings the user has already dealt with, here or on another device, so no later warning fires for them.
///
/// In memory only: it has to outlive one alert, not a relaunch. `checkEvents` runs on a background
/// run loop while the bridge records on the main thread, so every access goes through `queue`.
final class MeetingDismissalRegistry {
    static let shared = MeetingDismissalRegistry()

    /// Once a meeting is this far in the past nothing will alert for it again, so forget it.
    private static let retentionSeconds: TimeInterval = 4 * 60 * 60

    private let queue = DispatchQueue(label: "io.focusbear.latenomore.dismissals")
    private var dismissedMeetings: [MeetingIdentity] = []

    func record(_ meeting: MeetingIdentity, now: Date = Date()) {
        queue.sync {
            purgeExpired(now: now)
            guard !dismissedMeetings.contains(where: { $0.isSameMeeting(as: meeting) }) else { return }
            dismissedMeetings.append(meeting)
        }
    }

    func isDismissed(_ meeting: MeetingIdentity, now: Date = Date()) -> Bool {
        queue.sync {
            purgeExpired(now: now)
            return dismissedMeetings.contains { $0.isSameMeeting(as: meeting) }
        }
    }

    private func purgeExpired(now: Date) {
        let cutoff = now.addingTimeInterval(-Self.retentionSeconds)
        dismissedMeetings.removeAll { $0.startDate < cutoff }
    }
}

/// Encodes and decodes the notifications' `userInfo`. Pure, so it can be checked without either app running.
enum MeetingDismissalPayload {
    static func userInfo(for meeting: MeetingIdentity, reason: MeetingDismissReason) -> [String: String] {
        [
            FocusBearDismissalBridge.eventTitleKey: meeting.title,
            FocusBearDismissalBridge.eventBeginsKey: ISO8601DateFormatter().string(from: meeting.startDate),
            FocusBearDismissalBridge.dismissReasonKey: reason.rawValue
        ]
    }

    static func meeting(from userInfo: [AnyHashable: Any]?) -> MeetingIdentity? {
        guard let title = userInfo?[FocusBearDismissalBridge.eventTitleKey] as? String,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let begins = userInfo?[FocusBearDismissalBridge.eventBeginsKey] as? String,
              let startDate = parseDate(begins) else { return nil }
        return MeetingIdentity(title: title, startDate: startDate)
    }

    private static func parseDate(_ text: String) -> Date? {
        if let date = ISO8601DateFormatter().date(from: text) { return date }
        let withFractionalSeconds = ISO8601DateFormatter()
        withFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return withFractionalSeconds.date(from: text)
    }
}

/// Talks to the Focus Bear Mac app over distributed notifications.
enum FocusBearDismissalBridgeClient {

    /// Tell Focus Bear the user dealt with this meeting here, so it can silence their other devices.
    static func reportAcknowledgement(of meeting: MeetingIdentity, reason: MeetingDismissReason) {
        MeetingDismissalRegistry.shared.record(meeting)
        addLog(text: "dismissal bridge:- acknowledged here (\(reason.rawValue)), telling Focus Bear")
        DistributedNotificationCenter.default().postNotificationName(
            FocusBearDismissalBridge.acknowledgedNotification,
            object: nil,
            userInfo: MeetingDismissalPayload.userInfo(for: meeting, reason: reason),
            deliverImmediately: true)
    }

    /// Listen for meetings Focus Bear says were dealt with on another device. Call once, at launch.
    static func startObservingDismissalsElsewhere() {
        DistributedNotificationCenter.default().addObserver(
            forName: FocusBearDismissalBridge.dismissedElsewhereNotification,
            object: nil,
            queue: .main) { notification in
                guard let meeting = MeetingDismissalPayload.meeting(from: notification.userInfo) else {
                    addLog(text: "dismissal bridge:- ignoring a malformed dismissal from Focus Bear")
                    return
                }
                addLog(text: "dismissal bridge:- meeting dismissed on another device, stopping its alerts")
                MeetingDismissalRegistry.shared.record(meeting)
                closeAlerts(for: meeting)
            }
    }

    /// Close every alert and heads-up still showing for the meeting, which also stops the alert's speech.
    private static func closeAlerts(for meeting: MeetingIdentity) {
        for window in NSApplication.shared.windows {
            if let alertVc = window.contentViewController as? customAlertVc,
               alertVc.meeting?.isSameMeeting(as: meeting) == true {
                alertVc.closeWithoutReporting()
            } else if let warnVc = window.contentViewController as? warnUserVc,
                      warnVc.meeting?.isSameMeeting(as: meeting) == true {
                window.close()
            }
        }
    }
}
