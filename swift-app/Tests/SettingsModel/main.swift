//
//  main.swift
//  SettingsModel tests
//
//  The settings window's model (SettingsModel.swift, SettingsViewModel.swift). The app has no test
//  target, so scripts/test-settings-model.sh compiles this with those two files and runs it.
//

import Foundation

private var failures: [String] = []

private func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failures.append(name) }
}

private let RED = CalendarColor(red: 1, green: 0, blue: 0)
private let GMAIL = "jeremy@example.com"
private let ICLOUD = "iCloud"
private let OTHER = "Other"

private let work = CalendarOption(id: "work", title: "Work", accountTitle: GMAIL, color: RED)
private let holidays = CalendarOption(id: "holidays", title: "United States holidays", accountTitle: GMAIL, color: nil)
private let home = CalendarOption(id: "home", title: "Calendar", accountTitle: ICLOUD, color: RED)
private let family = CalendarOption(id: "family", title: "Family", accountTitle: ICLOUD, color: nil)
private let birthdays = CalendarOption(id: "birthdays", title: "Birthdays", accountTitle: OTHER, color: nil)
private let calendars = [work, home, birthdays, holidays, family]

private func time(_ hour: Int, _ minute: Int) -> TimeOfDay { TimeOfDay(hour: hour, minute: minute)! }

private func settings(enabled: Set<String> = ["work", "home"], keywords: [String] = ["no-notify"]) -> AlertSettings {
    AlertSettings(enabledCalendarIDs: enabled, ignoredKeywords: keywords, alertStartTime: time(7, 0), alertEndTime: time(21, 0))
}

// MARK: Grouping

let groups = CalendarGrouping.groups(of: calendars)
check(groups.map(\.accountTitle) == [ICLOUD, GMAIL, OTHER], "accounts are listed alphabetically")
check(groups.first?.calendars.map(\.title) == ["Calendar", "Family"], "calendars within an account are alphabetical")
check(groups.flatMap(\.calendars).count == calendars.count, "every calendar appears once")

let byTitle = CalendarGrouping.groups(of: calendars, matching: "  HOLI ")
check(byTitle.map(\.accountTitle) == [GMAIL] && byTitle.first?.calendars == [holidays],
      "a query matches calendar titles, ignoring case and surrounding spaces")
check(CalendarGrouping.groups(of: calendars, matching: "icloud").first?.calendars.count == 2,
      "a query matching an account keeps all its calendars")
check(CalendarGrouping.groups(of: calendars, matching: "zzz").isEmpty, "a query matching nothing gives no groups")
check(!CalendarGrouping.isFilterUseful(calendarCount: CalendarGrouping.FILTER_THRESHOLD),
      "no filter field for a short list")
check(CalendarGrouping.isFilterUseful(calendarCount: CalendarGrouping.FILTER_THRESHOLD + 1),
      "a filter field for a long list")

// MARK: Time of day

check(TimeOfDay(storageString: "06:30") == time(6, 30), "reads HH:mm")
check(TimeOfDay(storageString: "7:00") == time(7, 0), "reads the old unpadded default")
check(TimeOfDay(storageString: "25:00") == nil && TimeOfDay(storageString: "noon") == nil, "rejects bad times")
check(time(6, 30).storageString == "06:30", "writes zero-padded HH:mm")
check(TimeOfDay(date: time(19, 5).date()) == time(19, 5), "survives a round trip through Date")
check(settings().isAlertWindowEmpty == false, "7:00 to 21:00 is a real window")
var backwards = settings()
backwards.alertEndTime = time(6, 0)
check(backwards.isAlertWindowEmpty, "an end before the start is flagged")
backwards.alertEndTime = backwards.alertStartTime
check(backwards.isAlertWindowEmpty, "an end equal to the start is flagged")

// MARK: Keywords

check(KeywordList.adding("  focus  ", to: ["no-notify"]) == ["no-notify", "focus"], "adds a trimmed keyword")
check(KeywordList.adding("a, b,,c", to: []) == ["a", "b", "c"], "adds comma-separated keywords")
check(KeywordList.adding("No-Notify", to: ["no-notify"]) == ["no-notify"], "skips a duplicate in another case")
check(KeywordList.adding("   ", to: ["x"]) == ["x"], "skips blanks")
check(KeywordList.removing("b", from: ["a", "b", "c"]) == ["a", "c"], "removes a keyword")

// MARK: Calendar exclusions

check(CalendarExclusions.enabledIDs(of: calendars, excludedIDs: ["work", "gone"]) == ["home", "birthdays", "holidays", "family"],
      "calendars not excluded are on, and unknown exclusions are ignored")
check(CalendarExclusions.excluded(from: calendars, enabledIDs: ["work", "home", "family"])
        == [ExcludedCalendar(name: "Birthdays", id: "birthdays"), ExcludedCalendar(name: "United States holidays", id: "holidays")],
      "the file lists the calendars that are off, by name and id")

// MARK: View model

private var saves: [(settings: AlertSettings, previous: AlertSettings)] = []
private var launchAtLoginValues: [Bool] = []

private func makeModel(saveDelay: TimeInterval = 60) -> SettingsViewModel {
    saves = []
    launchAtLoginValues = []
    return SettingsViewModel(
        calendars: calendars,
        settings: settings(),
        launchesAtLogin: true,
        versionDescription: "2.0.27",
        saveDelay: saveDelay,
        persist: { saves.append(($0, $1)) },
        onLaunchAtLoginChange: { launchAtLoginValues.append($0) }
    )
}

var model = makeModel()
check(!model.hasUnsavedChanges && !model.saveNowIfChanged() && saves.isEmpty, "nothing to save before a change")
model.setCalendar(birthdays, enabled: true)
check(model.hasUnsavedChanges && model.enabledCalendarCount == 3, "turning a calendar on is a change")
model.setCalendar(birthdays, enabled: false)
check(!model.hasUnsavedChanges && !model.saveNowIfChanged(), "turning it back off is no change, so nothing saves")

model.setCalendar(home, enabled: false)
check(model.saveNowIfChanged() && saves.count == 1, "a real change saves once")
check(saves.first?.previous.enabledCalendarIDs == ["work", "home"] && saves.first?.settings.enabledCalendarIDs == ["work"],
      "the save gets the new settings and the ones they replace")
check(!model.saveNowIfChanged() && saves.count == 1 && model.hasSavedThisSession, "saving again with no change does nothing")

let icloudGroup = CalendarGrouping.groups(of: calendars).first { $0.accountTitle == ICLOUD }!
check(!model.areAllCalendarsEnabled(in: icloudGroup), "an account with calendars off isn't all on")
model.toggleAllCalendars(in: icloudGroup)
check(model.isCalendarEnabled(home) && model.isCalendarEnabled(family), "Select All turns the whole account on")
model.toggleAllCalendars(in: icloudGroup)
check(!model.isCalendarEnabled(home) && !model.isCalendarEnabled(family) && model.isCalendarEnabled(work),
      "Deselect All turns only that account off")

model = makeModel()
model.keywordDraft = "NO-NOTIFY"
check(!model.canAddKeywordDraft, "a duplicate draft can't be added")
model.keywordDraft = "[skiplnm]"
check(model.canAddKeywordDraft, "a new draft can be added")
model.addKeywordDraft()
check(model.settings.ignoredKeywords == ["no-notify", "[skiplnm]"] && model.keywordDraft.isEmpty, "adding keeps order and clears the draft")
model.removeKeyword("no-notify")
check(model.settings.ignoredKeywords == ["[skiplnm]"], "removing a keyword")

model.launchesAtLogin = false
check(launchAtLoginValues == [false], "the login setting applies straight away")

// Changes in quick succession save once, after the delay.
model = makeModel(saveDelay: 0.05)
model.setCalendar(birthdays, enabled: true)
model.settings.alertStartTime = time(6, 30)
model.settings.alertStartTime = time(6, 45)
check(saves.isEmpty, "nothing saves before the delay")
RunLoop.main.run(until: Date().addingTimeInterval(0.3))
check(saves.count == 1 && saves.first?.settings.alertStartTime == time(6, 45), "a burst of changes saves once, with the last value")

if failures.isEmpty {
    print("All settings model tests passed")
} else {
    print("\(failures.count) failed: \(failures.joined(separator: ", "))")
    exit(1)
}
