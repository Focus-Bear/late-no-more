import Foundation

var failures = 0
func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failures += 1 }
}

let MELBOURNE = TimeZone(identifier: "Australia/Melbourne")!
var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = MELBOURNE

func at(_ day: String, _ time: String) -> Date {
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.timeZone = MELBOURNE
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.date(from: "\(day) \(time)")!
}

/// The settings hand the checker today's date at the chosen time; only the time of day may count.
let SETTINGS_DAY = "2026-11-25"
let startTime = at(SETTINGS_DAY, "06:30:00")
let endTime = at(SETTINGS_DAY, "19:00:00")
func hours(on day: String, _ time: String) -> AlertHours {
    AlertHours(on: at(day, time), startTime: startTime, endTime: endTime, calendar: calendar)
}

let saturday = hours(on: "2026-11-28", "00:00:03")
check(saturday.start == at("2026-11-28", "06:30:00") && saturday.end == at("2026-11-28", "19:00:00"),
      "the hours are the settings' times on the day of the check, not the day the settings were saved")
check(saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "06:30:00")), "a meeting at the start time alerts")
check(saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "08:00:00")), "a meeting inside the hours alerts")
check(saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "18:59:00")), "a meeting a minute before the end alerts")
check(!saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "06:29:00")), "a meeting a minute before the start doesn't")
check(!saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "19:00:00")), "a meeting at the end time doesn't")
check(!saturday.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "23:55:00")), "a late-evening meeting doesn't")

// 28 Nov 2026, 00:00:03: a calendar block from 00:00 to 06:45 overlapped the 6:30 am-7 pm hours, so the
// overlap fetch returned it the moment the day changed, and its join prompt and verbal alerts fired at midnight.
let blockStart = at("2026-11-28", "00:00:00")
let blockEnd = at("2026-11-28", "06:45:00")
func overlapsFetch(_ hours: AlertHours) -> Bool { blockStart < hours.end && blockEnd > hours.start }
check(overlapsFetch(saturday), "replay: the overnight block overlaps the day's hours, so the fetch still returns it")
check(!saturday.allowsAlerts(forMeetingStartingAt: blockStart), "replay: but it starts outside them, so it no longer alerts")

let CHECK_INTERVAL_SECONDS: TimeInterval = 10
let checks = stride(from: at("2026-11-27", "23:00:00"), through: at("2026-11-28", "01:00:00"),
                    by: CHECK_INTERVAL_SECONDS).map { $0 }
let alertingChecks = checks.filter { checkTime in
    AlertHours(on: checkTime, startTime: startTime, endTime: endTime, calendar: calendar)
        .allowsAlerts(forMeetingStartingAt: blockStart)
}
check(alertingChecks.isEmpty, "replay: no check from 11 pm to 1 am lets the midnight block alert (\(checks.count) checks)")
check(!hours(on: "2026-11-27", "23:50:00").allowsAlerts(forMeetingStartingAt: at("2026-11-28", "00:00:00")),
      "a check before midnight doesn't alert for a meeting just after it")

let backwards = AlertHours(on: at("2026-11-28", "12:00:00"), startTime: endTime, endTime: startTime, calendar: calendar)
check(!backwards.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "12:00:00"))
      && !backwards.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "23:00:00"))
      && !backwards.allowsAlerts(forMeetingStartingAt: at("2026-11-28", "03:00:00")),
      "an end before the start leaves no hours, as the settings window warns")

// Melbourne's clocks went forward at 2 am on 4 Oct 2026; the hours still start at 6:30 local time.
let daylightSaving = hours(on: "2026-10-04", "00:00:05")
check(daylightSaving.start == at("2026-10-04", "06:30:00"), "the hours follow local time on a daylight-saving day")

if failures > 0 { print("\(failures) failed"); exit(1) }
print("all passed")
