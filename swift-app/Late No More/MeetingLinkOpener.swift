//
//  MeetingLinkOpener.swift
//  Late No More
//
//  Opens Join Now's meeting link where `MeetingLinkRouting` says: Focus Bear's browser or, as before,
//  the system's handler.
//

import AppKit

/// "Open meetings in Focus Bear's browser". On unless the user turned it off: it only matters once a
/// Focus Bear that can open links is installed.
enum OpenMeetingsInFocusBearSetting {
    static let userDefaultsKey = "kUserdefaultsOpenMeetingsInFocusBear"
    static let title = "Open meetings in Focus Bear's browser"
    static let explanation = "Join Now opens web meetings (Google Meet, Jitsi…) in Focus Bear's browser, beside your routine. Zoom, Teams, Webex and Skype links still open their own app when it's installed."

    static var isOn: Bool {
        get { UserDefaults.standard.object(forKey: userDefaultsKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: userDefaultsKey) }
    }
}

enum FocusBearInstallation {
    private static let infoPlistPath = "Contents/Info.plist"

    /// An installed Focus Bear, development or production build, has the `browser/open` route. Read from
    /// disk each time rather than through `Bundle`, which would keep an updated app's old Info.plist.
    static var canOpenBrowserLinks: Bool {
        FocusBearBrowserLink.focusBearBundleIdentifiers.contains { bundleIdentifier in
            guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else { return false }
            let info = NSDictionary(contentsOf: appURL.appendingPathComponent(infoPlistPath)) as? [String: Any]
            return FocusBearBrowserLink.isSupported(infoDictionary: info)
        }
    }
}

enum MeetingLinkOpener {
    static func open(_ link: URL) {
        let destination = MeetingLinkRouting.destination(
            for: link,
            canFocusBearOpenLinks: FocusBearInstallation.canOpenBrowserLinks,
            isOpenInFocusBearOn: OpenMeetingsInFocusBearSetting.isOn,
            isAppInstalled: { NSWorkspace.shared.urlForApplication(withBundleIdentifier: $0) != nil })
        switch destination {
        case .focusBearBrowser(let focusBearLink):
            addLog(text: "Join: opening the meeting on \(link.host ?? "") in Focus Bear's browser")
            if !NSWorkspace.shared.open(focusBearLink) {
                addLog(text: "Join: Focus Bear didn't take the link, opening it in the default browser")
                NSWorkspace.shared.open(link)
            }
        case .systemDefault:
            NSWorkspace.shared.open(link)
        }
    }
}
