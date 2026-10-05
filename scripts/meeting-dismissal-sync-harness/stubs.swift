// Stand-ins for the app types MeetingDismissalSync.swift touches; see scripts/test-meeting-dismissal-sync.sh.
import AppKit
func addLog(text: String) { print("log:", text) }
class customAlertVc: NSViewController {
    var meeting: MeetingIdentity?
    var closed = false
    override func loadView() { view = NSView() }
    func closeWithoutReporting() { closed = true }
}
class warnUserVc: NSViewController {
    var meeting: MeetingIdentity?
    override func loadView() { view = NSView() }
}
