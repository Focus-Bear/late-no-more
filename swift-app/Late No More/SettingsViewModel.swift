//
//  SettingsViewModel.swift
//  Late No More
//
//  Drives the settings window. Changes save themselves shortly after they are made: writing the
//  settings file is cheap, and the alert checker picks up new calendars and hours on its next tick
//  without a restart, so there is nothing an Apply button would protect.
//

import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    /// Long enough to coalesce stepper clicks and a burst of checkbox toggles into one save.
    static let SAVE_DELAY_SECONDS: TimeInterval = 0.6

    let calendars: [CalendarOption]
    let versionDescription: String

    @Published var settings: AlertSettings {
        didSet { scheduleSave() }
    }
    @Published var launchesAtLogin: Bool {
        didSet { onLaunchAtLoginChange(launchesAtLogin) }
    }
    @Published var calendarQuery = ""
    @Published var keywordDraft = ""
    @Published private(set) var hasSavedThisSession = false

    private var savedSettings: AlertSettings
    private var pendingSave: DispatchWorkItem?
    private let saveDelay: TimeInterval
    private let persist: (_ settings: AlertSettings, _ previous: AlertSettings) -> Void
    private let onLaunchAtLoginChange: (Bool) -> Void

    init(
        calendars: [CalendarOption],
        settings: AlertSettings,
        launchesAtLogin: Bool,
        versionDescription: String,
        saveDelay: TimeInterval = SAVE_DELAY_SECONDS,
        persist: @escaping (_ settings: AlertSettings, _ previous: AlertSettings) -> Void,
        onLaunchAtLoginChange: @escaping (Bool) -> Void
    ) {
        self.calendars = calendars
        self.settings = settings
        self.savedSettings = settings
        self.launchesAtLogin = launchesAtLogin
        self.versionDescription = versionDescription
        self.saveDelay = saveDelay
        self.persist = persist
        self.onLaunchAtLoginChange = onLaunchAtLoginChange
    }

    // MARK: Calendars

    var visibleCalendarGroups: [CalendarGroup] {
        CalendarGrouping.groups(of: calendars, matching: calendarQuery)
    }

    var isCalendarFilterShown: Bool {
        CalendarGrouping.isFilterUseful(calendarCount: calendars.count)
    }

    var enabledCalendarCount: Int {
        calendars.filter { settings.enabledCalendarIDs.contains($0.id) }.count
    }

    func isCalendarEnabled(_ calendar: CalendarOption) -> Bool {
        settings.enabledCalendarIDs.contains(calendar.id)
    }

    func setCalendar(_ calendar: CalendarOption, enabled: Bool) {
        setCalendars([calendar], enabled: enabled)
    }

    func areAllCalendarsEnabled(in group: CalendarGroup) -> Bool {
        group.calendars.allSatisfy(isCalendarEnabled)
    }

    /// Turns every calendar in the group on, or all of them off when they are already all on.
    func toggleAllCalendars(in group: CalendarGroup) {
        setCalendars(group.calendars, enabled: !areAllCalendarsEnabled(in: group))
    }

    private func setCalendars(_ calendars: [CalendarOption], enabled: Bool) {
        let ids = Set(calendars.map(\.id))
        settings.enabledCalendarIDs = enabled
            ? settings.enabledCalendarIDs.union(ids)
            : settings.enabledCalendarIDs.subtracting(ids)
    }

    // MARK: Keywords

    var canAddKeywordDraft: Bool {
        KeywordList.adding(keywordDraft, to: settings.ignoredKeywords) != settings.ignoredKeywords
    }

    func addKeywordDraft() {
        settings.ignoredKeywords = KeywordList.adding(keywordDraft, to: settings.ignoredKeywords)
        keywordDraft = ""
    }

    func removeKeyword(_ keyword: String) {
        settings.ignoredKeywords = KeywordList.removing(keyword, from: settings.ignoredKeywords)
    }

    // MARK: Saving

    var hasUnsavedChanges: Bool {
        settings != savedSettings
    }

    /// Saves straight away if anything changed since the last save. Called when the window closes or
    /// the app quits so a change made in the last moment isn't lost to the delay.
    @discardableResult
    func saveNowIfChanged() -> Bool {
        pendingSave?.cancel()
        pendingSave = nil
        guard hasUnsavedChanges else { return false }
        let previous = savedSettings
        savedSettings = settings
        persist(settings, previous)
        hasSavedThisSession = true
        return true
    }

    private func scheduleSave() {
        pendingSave?.cancel()
        let save = DispatchWorkItem { [weak self] in self?.saveNowIfChanged() }
        pendingSave = save
        DispatchQueue.main.asyncAfter(deadline: .now() + saveDelay, execute: save)
    }
}
