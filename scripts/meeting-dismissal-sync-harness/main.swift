// Checks for MeetingDismissalSync.swift; run scripts/test-meeting-dismissal-sync.sh.
import AppKit
var failures = 0
func check(_ c: Bool, _ m: String) { if !c { failures += 1; print("FAIL:", m) } else { print("ok:", m) } }
let t0 = Date(timeIntervalSince1970: 1_800_000_000)
let a = MeetingIdentity(title: "  Standup ", startDate: t0)
check(a.isSameMeeting(as: MeetingIdentity(title: "standup", startDate: t0.addingTimeInterval(59))), "case/trim + 59s drift matches")
check(!a.isSameMeeting(as: MeetingIdentity(title: "standup", startDate: t0.addingTimeInterval(61))), "61s drift does not match")
check(!a.isSameMeeting(as: MeetingIdentity(title: "Retro", startDate: t0)), "different title does not match")
check(!MeetingIdentity(title: " ", startDate: t0).isSameMeeting(as: MeetingIdentity(title: "", startDate: t0)), "empty titles never match")
let reg = MeetingDismissalRegistry()
reg.record(a, now: t0)
check(reg.isDismissed(MeetingIdentity(title: "STANDUP", startDate: t0.addingTimeInterval(30)), now: t0), "registry matches")
check(!reg.isDismissed(a, now: t0.addingTimeInterval(4*3600+1)), "registry purges after 4h")
let info = MeetingDismissalPayload.userInfo(for: a, reason: .joinedOnMac)
check(info["dismiss_reason"] == "joined_on_mac", "reason value on wire")
check(MeetingDismissalPayload.meeting(from: info) == a, "payload round-trips")
check(MeetingDismissalPayload.meeting(from: ["event_title": "X", "event_begins": "2026-09-14T09:00:00.000Z"])?.startDate == ISO8601DateFormatter().date(from: "2026-09-14T09:00:00Z"), "fractional seconds parse")
check(MeetingDismissalPayload.meeting(from: ["event_title": "", "event_begins": "2026-09-14T09:00:00Z"]) == nil, "empty title rejected")
check(MeetingDismissalPayload.meeting(from: ["event_title": "X"]) == nil, "missing start rejected")
// End to end over the real distributed notification center.
let live = MeetingIdentity(title: "Harness \(UUID().uuidString)", startDate: Date())
let alertVc = customAlertVc(); alertVc.meeting = live
_ = NSApplication.shared
let alertWindow = NSWindow(contentViewController: alertVc)
let otherVc = customAlertVc(); otherVc.meeting = MeetingIdentity(title: "Other \(UUID().uuidString)", startDate: Date())
let otherWindow = NSWindow(contentViewController: otherVc)
FocusBearDismissalBridgeClient.startObservingDismissalsElsewhere()
var heardAck: [AnyHashable: Any]?
DistributedNotificationCenter.default().addObserver(forName: FocusBearDismissalBridge.acknowledgedNotification, object: nil, queue: .main) { heardAck = $0.userInfo }
DistributedNotificationCenter.default().postNotificationName(FocusBearDismissalBridge.dismissedElsewhereNotification, object: nil, userInfo: MeetingDismissalPayload.userInfo(for: live, reason: .stopReminders), deliverImmediately: true)
FocusBearDismissalBridgeClient.reportAcknowledgement(of: MeetingIdentity(title: "Ack \(UUID().uuidString)", startDate: Date()), reason: .stopReminders)
let deadline = Date().addingTimeInterval(5)
while Date() < deadline && (heardAck == nil || !alertVc.closed) { RunLoop.main.run(until: Date().addingTimeInterval(0.1)) }
check(alertVc.closed, "dismissal from Focus Bear closes the matching alert")
check(!otherVc.closed, "dismissal from Focus Bear leaves other meetings' alerts open")
check(MeetingDismissalRegistry.shared.isDismissed(live), "dismissal from Focus Bear suppresses later warnings")
check((heardAck?["dismiss_reason"] as? String) == "stop_reminders", "acknowledgement reaches Focus Bear's channel")
print(failures == 0 ? "ALL PASSED" : "\(failures) FAILED"); exit(failures == 0 ? 0 : 1)
