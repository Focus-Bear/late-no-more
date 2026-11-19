//
//  main.swift
//  MeetingLinkRouting tests
//
//  Where Join Now opens a meeting link (MeetingLinkRouting.swift). The app has no test target, so
//  scripts/test-meeting-link-routing.sh compiles this with the routing file alone and runs it.
//

import Foundation

private var failures: [String] = []

private func expect(_ actual: MeetingLinkDestination, _ expected: MeetingLinkDestination, _ name: String) {
    if actual != expected { failures.append("\(name): expected \(expected), got \(actual)") }
}

private func expect(_ condition: Bool, _ name: String) {
    if !condition { failures.append(name) }
}

private let meetLink = URL(string: "https://meet.google.com/aee-ryqs-bxi")!
private let zoomLink = URL(string: "https://acme.zoom.us/j/123456789?pwd=abc")!
private let teamsLink = URL(string: "https://teams.microsoft.com/l/meetup-join/19%3ameeting_x%40thread.v2/0?context=%7b%7d")!
private let noAppsInstalled: (String) -> Bool = { _ in false }
private let zoomInstalled: (String) -> Bool = { $0 == "us.zoom.xos" }
private let newTeamsInstalled: (String) -> Bool = { $0 == "com.microsoft.teams2" }

private func destination(_ link: URL, canFocusBearOpenLinks: Bool = true, isSettingOn: Bool = true,
                         isAppInstalled: @escaping (String) -> Bool = noAppsInstalled) -> MeetingLinkDestination {
    MeetingLinkRouting.destination(for: link, canFocusBearOpenLinks: canFocusBearOpenLinks,
                                   isOpenInFocusBearOn: isSettingOn, isAppInstalled: isAppInstalled)
}

/// The page a Focus Bear link carries, decoded the way Focus Bear reads it.
private func page(in destination: MeetingLinkDestination) -> String? {
    guard case .focusBearBrowser(let link) = destination else { return nil }
    return URLComponents(url: link, resolvingAgainstBaseURL: false)?
        .queryItems?.first { $0.name == FocusBearBrowserLink.urlParameter }?.value
}

// A Meet link goes to Focus Bear's browser, carried whole.
let meet = destination(meetLink)
expect(page(in: meet) == meetLink.absoluteString, "Meet opens in Focus Bear's browser")
if case .focusBearBrowser(let link) = meet {
    expect(link.absoluteString.hasPrefix("focusbear://browser/open?url="), "the link is Focus Bear's browser/open route")
}

// A page with its own query keeps it, rather than splitting into the route's query.
let meetWithQuery = URL(string: "https://meet.google.com/aee-ryqs-bxi?authuser=1&hs=179")!
expect(page(in: destination(meetWithQuery)) == meetWithQuery.absoluteString, "a page's own ?, & and = survive")

// Without Focus Bear, or with the setting off, nothing changes.
expect(destination(meetLink, canFocusBearOpenLinks: false), .systemDefault, "no Focus Bear with the route: default browser")
expect(destination(meetLink, isSettingOn: false), .systemDefault, "setting off: default browser")

// Native apps keep their links.
expect(destination(zoomLink, isAppInstalled: zoomInstalled), .systemDefault, "Zoom with the Zoom app: unchanged")
expect(destination(teamsLink, isAppInstalled: newTeamsInstalled), .systemDefault, "Teams with the Teams app: unchanged")
expect(page(in: destination(zoomLink)) == zoomLink.absoluteString, "Zoom without the app: its web client in Focus Bear")
expect(page(in: destination(teamsLink)) == teamsLink.absoluteString, "Teams without the app: its web client in Focus Bear")
expect(page(in: destination(meetLink, isAppInstalled: zoomInstalled)) == meetLink.absoluteString,
       "the Zoom app doesn't keep a Meet link")

// Links that aren't web pages are never sent to Focus Bear.
for link in ["zoommtg://zoom.us/join?confno=123", "msteams:/l/meetup-join/abc", "file:///tmp/meeting.html", "mailto:a@b.co"] {
    expect(destination(URL(string: link)!), .systemDefault, "\(link) opens with the system")
}

// Focus Bear's Info.plist decides whether it has the route.
expect(FocusBearBrowserLink.isSupported(infoDictionary: [FocusBearBrowserLink.supportedInfoKey: true]), "key set: supported")
expect(!FocusBearBrowserLink.isSupported(infoDictionary: [:]), "an older Focus Bear: not supported")
expect(!FocusBearBrowserLink.isSupported(infoDictionary: nil), "no Info.plist: not supported")

if failures.isEmpty {
    print("MeetingLinkRouting: all checks passed")
} else {
    failures.forEach { print("FAIL: \($0)") }
    exit(1)
}
