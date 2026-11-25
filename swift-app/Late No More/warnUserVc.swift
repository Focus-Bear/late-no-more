//
//  warnUserVc.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//

import Cocoa

/// The 15-minute reminder's window. It is a heads-up, not a reason to switch apps: clicking an
/// ordinary window activates Late No More, and once the reminder closes AppKit hands key status to
/// the next window, which is the settings window `showMainWindow()` opened at launch. So the
/// reminder never activates the app and never becomes key.
enum ReminderPanel {
    static let TITLE = "Late No More"
    static let STYLE_MASK: NSWindow.StyleMask = [.titled, .closable, .nonactivatingPanel]
    static let LEVEL = NSWindow.Level.modalPanel

    static func make() -> NSPanel {
        let panel = NSPanel(contentRect: .zero, styleMask: STYLE_MASK, backing: .buffered, defer: true)
        panel.title = TITLE
        panel.level = LEVEL
        // Panels hide whenever their app is inactive by default, and Late No More is almost never the active app.
        panel.hidesOnDeactivate = false
        panel.becomesKeyOnlyIfNeeded = true
        panel.isReleasedWhenClosed = false
        return panel
    }

    /// `showWindow` would make the panel key, and a key non-activating panel takes the keyboard from whatever the user is typing in.
    static func show(_ panel: NSWindow?) {
        panel?.orderFrontRegardless()
    }
}

/// The reminder panel never becomes key, so every click on it is a first click; without this the
/// first click on "Got it" would be swallowed instead of dismissing the reminder.
class ReminderButton: Button {
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }
}

class warnUserVc: NSViewController {
    var calendarDismissalIdentity: SharedCalendarDismissals.Identity?

    @IBOutlet weak var btnGotIt: ReminderButton!
    @IBOutlet weak var lblSubTitle: NSTextField!
    @IBOutlet weak var lblTitle: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        lblTitle.stringValue = "Late No More: (evt.summary) ((evt.calendarName)) is starting in 15 minutes."
        lblSubTitle.stringValue = "I'll remind you again (DialogConfig.LOOK_AHEAD_MINUTES) minutes before."
        btnGotIt.title = "Got it"
    }
    
    func resetData(title:String, calendarName:String){
        lblTitle.stringValue = "Late No More: \(title) (\(calendarName)) is starting in 15 minutes."
        lblSubTitle.stringValue = "I'll remind you again 2 minutes before."
    }
    
    @IBAction func btnGotItClicked(_ sender: Any) {
        self.view.window?.close()
    }
}
