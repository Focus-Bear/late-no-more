//
//  SettingsText.swift
//  Late No More
//
//  Every string the settings window shows. The app has no string tables yet, so these go through
//  NSLocalizedString with their English value: adding a Localizable.strings later translates them
//  without touching the views.
//

import Foundation

enum SettingsText {
    static let calendarsTitle = localized("settings.calendars.title", "Calendars")
    static let calendarsFootnote = localized(
        "settings.calendars.footnote", "Late No More reminds you about meetings in the calendars you tick.")
    static let calendarsOtherAccount = localized("settings.calendars.otherAccount", "Other")
    static let calendarsFilterPlaceholder = localized("settings.calendars.filter", "Filter calendars")
    static let calendarsClearFilter = localized("settings.calendars.clearFilter", "Clear filter")
    static let calendarsNone = localized(
        "settings.calendars.none",
        "Late No More can't see any calendars. Allow calendar access in System Settings › Privacy & Security › Calendars, then reopen this window.")
    static let calendarsNoMatchFormat = localized("settings.calendars.noMatch", "No calendars match “%@”.")
    static let calendarsEnabledCountFormat = localized("settings.calendars.enabledCount", "%d of %d on")
    static let calendarsSelectAll = localized("settings.calendars.selectAll", "Select All")
    static let calendarsDeselectAll = localized("settings.calendars.deselectAll", "Deselect All")
    static let calendarsSelectAllHintFormat = localized(
        "settings.calendars.selectAllHint", "Turns every %@ calendar on or off")

    static let keywordsTitle = localized("settings.keywords.title", "Ignore events with keywords")
    static let keywordsFootnote = localized(
        "settings.keywords.footnote", "Events whose title contains any of these words won't trigger reminders.")
    static let keywordsPlaceholder = localized("settings.keywords.placeholder", "Add a keyword, e.g. no-notify")
    static let keywordsAdd = localized("settings.keywords.add", "Add")
    static let keywordsEmpty = localized("settings.keywords.empty", "No keywords yet.")
    static let keywordsRemoveFormat = localized("settings.keywords.remove", "Remove keyword %@")

    static let hoursTitle = localized("settings.hours.title", "Alert hours")
    static let hoursBetween = localized("settings.hours.between", "Remind me between")
    static let hoursAnd = localized("settings.hours.and", "and")
    static let hoursStartLabel = localized("settings.hours.start", "Start time")
    static let hoursEndLabel = localized("settings.hours.end", "End time")
    static let hoursFootnote = localized(
        "settings.hours.footnote", "Meetings that start outside these hours don't get popups or spoken alerts.")
    static let hoursEmptyWindowWarning = localized(
        "settings.hours.emptyWindow", "The end time is at or before the start time, so you won't get any reminders.")

    static let generalTitle = localized("settings.general.title", "General")
    static let launchAtLogin = localized("settings.general.launchAtLogin", "Open Late No More at login")
    static let advancedDescription = localized(
        "settings.general.advancedDescription", "Voice, alert messages and intention prompts")
    static let advancedButton = localized("settings.general.advancedButton", "Advanced…")

    static let savedAutomatically = localized("settings.footer.savedAutomatically", "Changes save automatically")
    static let saved = localized("settings.footer.saved", "Saved")
    static let versionFormat = localized("settings.footer.version", "Version %@")
    static let broughtToYouBy = localized("settings.footer.broughtToYouBy", "Brought to you by Focus Bear.")
    static let focusBearLink = localized("settings.footer.link", "focusbear.io")
    static let footerSeparator = "·"

    private static func localized(_ key: String, _ english: String) -> String {
        NSLocalizedString(key, value: english, comment: "")
    }
}
