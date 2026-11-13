//
//  SettingsModel.swift
//  Late No More
//
//  The settings window's data and rules, kept free of AppKit and EventKit so
//  scripts/test-settings-model.sh can compile and test it on its own.
//

import Foundation

struct CalendarColor: Equatable {
    let red: Double
    let green: Double
    let blue: Double
}

struct CalendarOption: Identifiable, Equatable {
    let id: String
    let title: String
    let accountTitle: String
    let color: CalendarColor?
}

struct CalendarGroup: Identifiable, Equatable {
    let accountTitle: String
    let calendars: [CalendarOption]

    var id: String { accountTitle }
}

enum CalendarGrouping {
    /// Below this many calendars the whole list fits on screen, so a filter field is just clutter.
    static let FILTER_THRESHOLD = 8

    static func isFilterUseful(calendarCount: Int) -> Bool {
        calendarCount > FILTER_THRESHOLD
    }

    /// Calendars grouped by account, accounts and calendars in alphabetical order. A query matching an
    /// account name keeps all of that account's calendars.
    static func groups(of calendars: [CalendarOption], matching query: String = "") -> [CalendarGroup] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let byAccount = Dictionary(grouping: calendars, by: \.accountTitle)
        return byAccount.keys
            .sorted(by: isOrderedAlphabetically)
            .compactMap { account in
                let accountCalendars = byAccount[account] ?? []
                let visible = trimmedQuery.isEmpty || account.localizedCaseInsensitiveContains(trimmedQuery)
                    ? accountCalendars
                    : accountCalendars.filter { $0.title.localizedCaseInsensitiveContains(trimmedQuery) }
                guard !visible.isEmpty else { return nil }
                return CalendarGroup(
                    accountTitle: account,
                    calendars: visible.sorted { isOrderedAlphabetically($0.title, $1.title) }
                )
            }
    }

    private static func isOrderedAlphabetically(_ first: String, _ second: String) -> Bool {
        first.localizedStandardCompare(second) == .orderedAscending
    }
}

struct TimeOfDay: Equatable, Comparable {
    private static let MINUTES_PER_HOUR = 60
    private static let HOURS_PER_DAY = 24
    private static let SEPARATOR: Character = ":"

    let hour: Int
    let minute: Int

    init?(hour: Int, minute: Int) {
        guard (0..<Self.HOURS_PER_DAY).contains(hour), (0..<Self.MINUTES_PER_HOUR).contains(minute) else { return nil }
        self.hour = hour
        self.minute = minute
    }

    /// Reads the settings file's "HH:mm" (also the older unpadded "7:00").
    init?(storageString: String) {
        let parts = storageString.trimmingCharacters(in: .whitespaces).split(separator: Self.SEPARATOR)
        guard parts.count == 2, let hour = Int(parts[0]), let minute = Int(parts[1]) else { return nil }
        self.init(hour: hour, minute: minute)
    }

    init(date: Date, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        hour = components.hour ?? 0
        minute = components.minute ?? 0
    }

    /// The "HH:mm" form the settings file uses (see README, barkStartTime).
    var storageString: String {
        String(format: "%02d:%02d", hour, minute)
    }

    var minutesSinceMidnight: Int {
        hour * Self.MINUTES_PER_HOUR + minute
    }

    func date(on day: Date = Date(), calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }

    static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        lhs.minutesSinceMidnight < rhs.minutesSinceMidnight
    }
}

enum KeywordList {
    private static let SEPARATORS = CharacterSet(charactersIn: ",\n")

    /// Adds each comma-separated keyword in `entry`, skipping blanks and ones already present. Matching
    /// ignores case, so "No-Notify" would duplicate "no-notify".
    static func adding(_ entry: String, to keywords: [String]) -> [String] {
        entry.components(separatedBy: SEPARATORS)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .reduce(keywords) { result, keyword in
                contains(keyword, in: result) ? result : result + [keyword]
            }
    }

    static func removing(_ keyword: String, from keywords: [String]) -> [String] {
        keywords.filter { $0 != keyword }
    }

    /// Whether an event with this title should be skipped: its title contains a keyword, ignoring case,
    /// as the Node engine matched them.
    static func isIgnored(eventTitle: String?, keywords: [String]) -> Bool {
        guard let title = eventTitle else { return false }
        return keywords.contains { keyword in
            let trimmed = keyword.trimmingCharacters(in: .whitespaces)
            return !trimmed.isEmpty && title.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private static func contains(_ keyword: String, in keywords: [String]) -> Bool {
        keywords.contains { $0.caseInsensitiveCompare(keyword) == .orderedSame }
    }
}

/// The settings shown in the window. The voice, alert-message and prompt settings live in the Advanced
/// sheet's globals and are saved alongside these.
struct AlertSettings: Equatable {
    var enabledCalendarIDs: Set<String>
    var ignoredKeywords: [String]
    var alertStartTime: TimeOfDay
    var alertEndTime: TimeOfDay

    /// The engine only looks for events between the two times, so an end at or before the start means
    /// no reminders at all.
    var isAlertWindowEmpty: Bool {
        alertEndTime <= alertStartTime
    }
}

struct ExcludedCalendar: Equatable {
    let name: String
    let id: String
}

/// The settings file stores the calendars to leave out, not the ones to include, so a newly added
/// calendar is on by default.
enum CalendarExclusions {
    static func enabledIDs(of calendars: [CalendarOption], excludedIDs: Set<String>) -> Set<String> {
        Set(calendars.map(\.id)).subtracting(excludedIDs)
    }

    static func excluded(from calendars: [CalendarOption], enabledIDs: Set<String>) -> [ExcludedCalendar] {
        calendars
            .filter { !enabledIDs.contains($0.id) }
            .map { ExcludedCalendar(name: $0.title, id: $0.id) }
    }
}
