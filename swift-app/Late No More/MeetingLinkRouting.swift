//
//  MeetingLinkRouting.swift
//  Late No More
//
//  Where Join Now opens a meeting link. With Focus Bear installed, a web meeting opens in Focus Bear's
//  own browser, beside the user's routine, instead of the default browser (Focus Bear report
//  2026-10-26_16-43-11: "this should open in Focus Bear browser rather than in chrome").
//
//  Foundation only, so scripts/test-meeting-link-routing.sh can compile and test it on its own.
//

import Foundation

enum MeetingLinkDestination: Equatable {
    /// `focusbear://browser/open?url=…`, which Focus Bear opens in a new tab of its browser.
    case focusBearBrowser(URL)
    /// The system's handler for the link itself: the default browser, or a meeting app's own scheme.
    case systemDefault
}

/// A meeting service whose desktop app takes over its web links. Its links keep opening as before when
/// the app is installed, so the call still lands in the app rather than its web client.
struct NativeMeetingApp {
    /// Matched by suffix, so per-organisation hosts (`acme.zoom.us`, `acme.webex.com`) count.
    let hostSuffixes: [String]
    let bundleIdentifiers: [String]

    func handles(host: String) -> Bool {
        hostSuffixes.contains { host == $0 || host.hasSuffix("." + $0) }
    }
}

enum MeetingLinkRouting {
    static let webSchemes: Set<String> = ["http", "https"]

    static let nativeMeetingApps = [
        NativeMeetingApp(hostSuffixes: ["zoom.us", "zoomgov.com"], bundleIdentifiers: ["us.zoom.xos"]),
        NativeMeetingApp(hostSuffixes: ["teams.microsoft.com", "teams.live.com", "teams.cloud.microsoft"],
                         bundleIdentifiers: ["com.microsoft.teams2", "com.microsoft.teams"]),
        NativeMeetingApp(hostSuffixes: ["webex.com"], bundleIdentifiers: ["Cisco-Systems.Spark"]),
        NativeMeetingApp(hostSuffixes: ["skype.com"], bundleIdentifiers: ["com.skype.skype"]),
    ]

    /// - Parameters:
    ///   - canFocusBearOpenLinks: an installed Focus Bear has the `browser/open` route.
    ///   - isOpenInFocusBearOn: the "Open meetings in Focus Bear's browser" setting.
    ///   - isAppInstalled: whether the app with this bundle identifier is installed.
    static func destination(for link: URL, canFocusBearOpenLinks: Bool, isOpenInFocusBearOn: Bool,
                            isAppInstalled: (String) -> Bool) -> MeetingLinkDestination {
        guard canFocusBearOpenLinks, isOpenInFocusBearOn,
              webSchemes.contains(link.scheme?.lowercased() ?? ""),
              let host = link.host?.lowercased(), !host.isEmpty,
              !opensInNativeApp(host: host, isAppInstalled: isAppInstalled),
              let focusBearLink = FocusBearBrowserLink.link(opening: link) else { return .systemDefault }
        return .focusBearBrowser(focusBearLink)
    }

    private static func opensInNativeApp(host: String, isAppInstalled: (String) -> Bool) -> Bool {
        nativeMeetingApps.contains { app in
            app.handles(host: host) && app.bundleIdentifiers.contains(where: isAppInstalled)
        }
    }
}

/// Focus Bear's `focusbear://browser/open?url=<page>` route (`BrowserOpenLink` in the Focus Bear app).
enum FocusBearBrowserLink {
    static let scheme = "focusbear"
    static let host = "browser"
    static let path = "/open"
    static let urlParameter = "url"
    /// Focus Bear's Info.plist key saying the installed build has the route. An older build would drop
    /// the link, and the meeting would not open at all.
    static let supportedInfoKey = "FBBrowserOpenLinkSupported"
    /// Focus Bear's development and production builds.
    static let focusBearBundleIdentifiers = ["com.App.EarnYourScreentime", "com.focusbear.screentime"]

    /// Unreserved URL characters. The page is encoded whole: left as it is, its own `?`, `&` and `=`
    /// would split into the route's query.
    private static let unreservedCharacters = CharacterSet(charactersIn:
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")

    static func link(opening page: URL) -> URL? {
        guard let encodedPage = page.absoluteString.addingPercentEncoding(withAllowedCharacters: unreservedCharacters) else {
            return nil
        }
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.percentEncodedQuery = urlParameter + "=" + encodedPage
        return components.url
    }

    /// Whether an installed Focus Bear's Info.plist says it has the route.
    static func isSupported(infoDictionary: [String: Any]?) -> Bool {
        infoDictionary?[supportedInfoKey] as? Bool == true
    }
}
