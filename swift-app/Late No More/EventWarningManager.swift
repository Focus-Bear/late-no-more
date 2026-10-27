//
//  EventWarningManager.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//


import EventKit

class EventWarningManager {
    // MARK: - Properties
    private static let CHECK_QUEUE_LABEL = "com.focusbear.latenomore.calendar-check"
    private static let TIMER_LEEWAY = DispatchTimeInterval.seconds(1)
    private static let EVENT_DATE_FORMAT = "EEEE, d MMMM yyyy, h:mm a"

    private let calendarManager = CalendarManager()
    /// Every check, and all the state below, runs on this queue: EventKit fetches stay off the main
    /// thread, and two checks never overlap. A user-initiated QoS keeps the check scheduled on a busy Mac.
    private let checkQueue = DispatchQueue(label: CHECK_QUEUE_LABEL, qos: .userInitiated)
    private var timer: DispatchSourceTimer?
    private var shownWarnings: [String: Set<MeetingWarning>] = [:]
    private var arrCalendars: [[String: Any]] = []
    private var pickerStartTimeDateValue: Date!
    private var pickerEndTimeDateValue: Date!
    var timeInterval = 10
    /// When the previous check ran, so a warning whose moment fell between two checks is still shown.
    private var lastCheckDate: Date?
    private var eventListLog = ChangedListFilter()
    private let eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = EVENT_DATE_FORMAT
        return formatter
    }()

    // MARK: - Initialization
    func resetData(calendars: [[String: Any]], startTimePicker: NSDatePicker, endTimePicker: NSDatePicker) {
        let startTime = startTimePicker.dateValue
        let endTime = endTimePicker.dateValue
        checkQueue.async {
            self.arrCalendars = calendars
            self.pickerStartTimeDateValue = startTime
            self.pickerEndTimeDateValue = endTime
        }
    }
    
    // MARK: - Public Methods
    func startCheck() {
        addLog(text: "func:- startCheck")
        stopCheck() // Stop any existing timer
        setupTimer()
    }
    
    func stopCheck() {
        timer?.cancel()
        timer = nil
    }
    
    // MARK: - Private Methods
    /// A dispatch timer, unlike the run-loop `Timer` it replaces, can be cancelled from any thread. That one
    /// was invalidated from the main thread although it ran on a background run loop, so a restart could
    /// leave the old timer checking alongside the new one.
    private func setupTimer() {
        addLog(text: "func:- setupTimer checkEvents")
        let interval = DispatchTimeInterval.seconds(timeInterval)
        let timer = DispatchSource.makeTimerSource(queue: checkQueue)
        timer.schedule(deadline: .now() + interval, repeating: interval, leeway: Self.TIMER_LEEWAY)
        timer.setEventHandler { [weak self] in self?.checkEvents() }
        timer.resume()
        self.timer = timer
    }
    
    private func checkEvents() {
        addLog(text: "func:- checkEvents")
        var calendarsToCheck = [EKCalendar]()
        for calendar in arrCalendars {
            if let state = calendar["state"] as? Bool, state,
               let cal = calendar["calendar"] as? EKCalendar {
                calendarsToCheck.append(cal)
            }
        }
        
        
        let startDateTime = combineCurrentDateWithTime(from: pickerStartTimeDateValue)
        let endDateTime = combineCurrentDateWithTime(from: pickerEndTimeDateValue)
        
        let fetchStart = Date()
        let events = calendarManager.fetchEvents(from: startDateTime, to: endDateTime, in: calendarsToCheck)
            .filter { !$0.isAllDay && $0.startDate != nil }
        let currentDate = Date()
        let secondsSinceLastCheck = lastCheckDate.map { currentDate.timeIntervalSince($0) }
        defer { lastCheckDate = currentDate }
        logIfLate(secondsSinceLastCheck: secondsSinceLastCheck, fetchSeconds: currentDate.timeIntervalSince(fetchStart))
        logEventListIfChanged(events)

        for event in events {
            let startDateTime: Date = event.startDate
            let eventId = event.eventIdentifier ?? UUID().uuidString
            var shownTimes = shownWarnings[eventId] ?? Set()
            let timeUntilEvent = startDateTime.timeIntervalSince(currentDate)

            for warning in WarningTiming.dueWarnings(timeUntilEvent: timeUntilEvent,
                                                     secondsSinceLastCheck: secondsSinceLastCheck,
                                                     tolerance: TimeInterval(timeInterval), alreadyShown: shownTimes) {
                let lateness = warning.secondsBeforeStart - timeUntilEvent
                if lateness > TimeInterval(timeInterval) {
                    addLog(text: "Event '\(event.title ?? "")' \(warning.rawValue) warning caught up \(Int(lateness)) s late")
                }
                showWarnWindow(for: warning, event: event)
                shownTimes.insert(warning)
                shownWarnings[eventId] = shownTimes
            }
            // Cleanup past events
            if timeUntilEvent < -WarningTiming.pastEventCleanupSeconds {
                shownWarnings.removeValue(forKey: eventId)
            }
        }
    }

    private func logIfLate(secondsSinceLastCheck: TimeInterval?, fetchSeconds: TimeInterval) {
        guard let secondsLate = WarningTiming.secondsLate(secondsSinceLastCheck: secondsSinceLastCheck,
                                                          checkInterval: TimeInterval(timeInterval)) else { return }
        addLog(text: "checkEvents ran \(Int(secondsLate)) s late: \(Int(secondsSinceLastCheck ?? 0)) s since the previous check, calendar fetch took \(Int(fetchSeconds)) s")
    }

    /// The day's events, only when they differ from the last check's. Logging them every 10 seconds is what
    /// grew the log to 3.6 GB.
    private func logEventListIfChanged(_ events: [EKEvent]) {
        let lines = events.map { event in
            "event:- name: \(event.title ?? ""), dateTime: Today, \(eventDateFormatter.string(from: event.startDate))"
        }
        guard let changedLines = eventListLog.changed(lines) else { return }
        addLog(text: "events:- \(changedLines.count) in the alert hours (changed since the last check)")
        changedLines.forEach { addLog(text: $0) }
    }
    
    private func combineCurrentDateWithTime(from time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        combinedComponents.second = timeComponents.second
        
        return calendar.date(from: combinedComponents) ?? Date()
    }
    
    private func showWarnWindow(for warningTime: MeetingWarning, event: EKEvent) {
        DispatchQueue.main.async {
            let message: String
            switch warningTime {
            case .fifteenMinutes:
                message = "Event '\(event.title ?? "")' starts in 15 minutes"
                Late_No_More.showWarnWindow(title: event.title, calendarName: event.calendar.title)
                addLog(text: "Event '\(event.title ?? "")' starts in 15 minutes")
            case .twoMinutes:
                var eventUrl:URL?
//                if let url = getEventUrl(event: event){
//                    print(url)
//                    eventUrl = url
//                }else
                
                if let urlString = event.location{
                    if let url = URL(string: urlString) {
                        if #available(macOS 13.0, *) {
                            if url.host() != nil{
                                eventUrl = url
                            }
                        } else {
                            if url.host != nil{
                                eventUrl = url
                            }
                        }
                    }
                }
                if eventUrl == nil{
                    if let url = event.url{
                        if #available(macOS 13.0, *) {
                            if url.host() != nil{
                                eventUrl = url
                            }
                        } else {
                            if url.host != nil{
                                eventUrl = url
                            }
                        }
                    }
                }
                
                let eventUrlString = eventUrl?.absoluteString ?? ""
                message = "Event '\(event.title ?? "")' starts in 2 minutes and Event url is '\(eventUrlString)'"
                addLog(text: "Event '\(event.title ?? "")' starts in 2 minutes and Event url is '\(eventUrlString)'")
                let eventId = event.eventIdentifier ?? ""
                Late_No_More.showtCustomAlertWindow(title: event.title, time: event.startDate, url: eventUrl,notes: event.notes ?? "", eventId:eventId)
                
                
                if let url = FocusBearTrigger.eventAboutToStartURL(title: event.title ?? "", start: event.startDate, end: event.endDate) {
                    addLog(text: "Triggering FB event-about-to-start: \(url.absoluteString)")
                    FocusBearTrigger.send(url)
                }
            case .eventTime:
                message = "Event '\(event.title ?? "")' is starting now"
                addLog(text: "Event '\(event.title ?? "")' verbal alert")
                let eventId = event.eventIdentifier ?? ""
                for wcObj in arrAlertWcObj{
                    if wcObj.window?.isVisible ?? false{
                        if let customAlertVcObj = wcObj.contentViewController as? customAlertVc{
                            if customAlertVcObj.eventId == eventId{
                                customAlertVcObj.meetingTimeShowVerbalAlerts()
                                // Something may have covered the alert since it appeared; the meeting is starting.
                                if let window = wcObj.window {
                                    AlertWindowPresentation.bringToFront(window)
                                }
                                break;
                            }
                        }
                    }
                }
            }
            
            // Replace with your actual warning window implementation
            print("Showing warning: \(message)")
            // YourWindowController.shared.show(message: message)
        }
    }
}

//func getEventUrl(event:EKEvent)-> URL?{
//    if let notes = event.notes {
//        let types: NSTextCheckingResult.CheckingType = .link
//        let detector = try? NSDataDetector(types: types.rawValue)
//        let matches = detector?.matches(in: notes, options: [], range: NSRange(location: 0, length: notes.utf16.count))
//        
//        for match in matches ?? [] {
//            guard let range = Range(match.range, in: notes) else { continue }
//            let urlString = String(notes[range])
//            if let url = URL(string: urlString) {
//                return url
//            }
//        }
//    }
//    return nil
//}

// MARK: - WarningTiming

/// The moments a meeting is announced, earliest first.
enum MeetingWarning: String, CaseIterable {
    case fifteenMinutes = "15 minutes"
    /// The join prompt: the alert with Join Now, plus Focus Bear's event-about-to-start trigger.
    case twoMinutes = "2 minutes"
    /// The verbal alerts, played on the join prompt.
    case eventTime = "event time"

    var secondsBeforeStart: TimeInterval {
        switch self {
        case .fifteenMinutes: return 900
        case .twoMinutes: return 120
        case .eventTime: return 0
        }
    }

    /// The latest a caught-up warning is still shown, in seconds after the meeting's start (negative:
    /// before it). The 15-minute warning gives way to the join prompt; the join prompt and the verbal
    /// alerts are still worth having for a while after the start.
    var latestSecondsAfterStart: TimeInterval {
        switch self {
        case .fifteenMinutes: return -MeetingWarning.twoMinutes.secondsBeforeStart
        case .twoMinutes, .eventTime: return WarningTiming.missedTriggerGraceSeconds
        }
    }
}

/// When a warning is due. It used to be due only when a check landed within `tolerance` of its exact
/// moment, so a check that ran late skipped it for good. On 21 Oct 2026 one 10-second check started at
/// 12:42:47 and stalled until 12:44:37 on a busy Mac; the 12:45 meeting's two-minute window
/// (12:42:50-12:43:10) fell inside the stall, so neither the alert nor Focus Bear's
/// event-about-to-start trigger was sent. A warning whose moment passed since the previous check is now
/// shown late. The first check after launch still shows only on-time warnings, so opening the app doesn't
/// replay a meeting's earlier warnings.
///
/// On 27 Oct 2026 that catch-up still missed the 12:45 meeting: the checks stalled from 12:40:29 to 12:44:29
/// (load average 140-300), and the 12:44:29 check's calendar fetch took until 12:45:08. By then the join
/// prompt was 8 s past its limit, the meeting's start, so it was skipped, and the start alert had no prompt
/// to play on. Missed join prompts and start alerts are now caught up until `missedTriggerGraceSeconds`
/// after the start, and a start alert with no join prompt brings the prompt up first.
enum WarningTiming {
    static let missedTriggerGraceSeconds: TimeInterval = 5 * 60
    /// A started event's warnings are forgotten this long after its start: after the grace, so a caught-up
    /// warning can't be shown a second time.
    static let pastEventCleanupSeconds: TimeInterval = missedTriggerGraceSeconds + 60
    /// A check this much later than its interval is logged.
    static let lateCheckLogSeconds: TimeInterval = 30

    static func isDue(_ warning: MeetingWarning, timeUntilEvent: TimeInterval, secondsSinceLastCheck: TimeInterval?,
                      tolerance: TimeInterval) -> Bool {
        let lateness = warning.secondsBeforeStart - timeUntilEvent
        guard lateness >= -tolerance, -timeUntilEvent <= warning.latestSecondsAfterStart else { return false }
        if lateness <= tolerance { return true }
        guard let secondsSinceLastCheck else { return false }
        return lateness <= secondsSinceLastCheck + tolerance
    }

    /// The warnings this check shows for one meeting, in order. Each is shown at most once per meeting.
    static func dueWarnings(timeUntilEvent: TimeInterval, secondsSinceLastCheck: TimeInterval?, tolerance: TimeInterval,
                            alreadyShown: Set<MeetingWarning>) -> [MeetingWarning] {
        var due = MeetingWarning.allCases.filter { warning in
            !alreadyShown.contains(warning) && isDue(warning, timeUntilEvent: timeUntilEvent,
                                                     secondsSinceLastCheck: secondsSinceLastCheck, tolerance: tolerance)
        }
        if due.contains(.twoMinutes) { due.removeAll { $0 == .fifteenMinutes } }
        if let startIndex = due.firstIndex(of: .eventTime), !due.contains(.twoMinutes),
           !alreadyShown.contains(.twoMinutes) {
            due.insert(.twoMinutes, at: startIndex)
        }
        return due
    }

    /// How late a check ran, when that's more than `lateCheckLogSeconds`.
    static func secondsLate(secondsSinceLastCheck: TimeInterval?, checkInterval: TimeInterval) -> TimeInterval? {
        guard let secondsSinceLastCheck else { return nil }
        let secondsLate = secondsSinceLastCheck - checkInterval
        return secondsLate > lateCheckLogSeconds ? secondsLate : nil
    }
}

// MARK: - FocusBearTrigger

/// Tells Focus Bear a meeting is about to start, alongside the two-minute alert.
enum FocusBearTrigger {
    static let eventAboutToStartBase = "focusbear://event-about-to-start"

    static func eventAboutToStartURL(title: String, start: Date, end: Date) -> URL? {
        let formatter = ISO8601DateFormatter()
        let allowedCharacters = CharacterSet.urlQueryAllowed
        let encode = { (value: String) in value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? "" }
        let query = "event_title=\(encode(title))&event_start_time=\(encode(formatter.string(from: start)))"
            + "&event_end_time=\(encode(formatter.string(from: end)))"
        return URL(string: "\(eventAboutToStartBase)?\(query)")
    }

    /// Opening the link used to make Focus Bear the active app, the moment the two-minute alert went up.
    /// Since macOS 14 an inactive app's window only goes in front "conditionally", so the alert could end up
    /// beneath Focus Bear's and then the user's windows. Focus Bear only needs the link, not the focus.
    static var openConfiguration: NSWorkspace.OpenConfiguration {
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = false
        return configuration
    }

    static func send(_ url: URL) {
        NSWorkspace.shared.open(url, configuration: openConfiguration) { _, error in
            if let error {
                addLog(text: "Triggering FB event-about-to-start failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - AlertWindowPresentation

/// How the meeting alerts go on screen. Late No More is never the active app when an alert fires, and
/// since macOS 14 `showWindow` from an inactive app only orders the window front "conditionally": it may go
/// beneath the active app's windows. On 21 Oct 2026 the 4:45 pm meeting's two-minute alert was ordered
/// front at 16:42:58 (macOS log: "ordered front from a non-active application and may order beneath the
/// active application's windows") and the user first saw it at 16:45, when the 15-minute alert for the next
/// meeting was closed on top of it. `orderFrontRegardless` puts the alert in front whichever app is active,
/// and the collection behaviour keeps it on the Space the user is on, also over a full-screen app.
enum AlertWindowPresentation {
    static let level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.modalPanelWindow)))
    static let collectionBehavior: NSWindow.CollectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

    static func present(_ windowController: NSWindowController) {
        guard let window = windowController.window else { return }
        window.level = level
        window.collectionBehavior.formUnion(collectionBehavior)
        windowController.showWindow(nil)
        window.center()
        bringToFront(window)
    }

    static func bringToFront(_ window: NSWindow) {
        window.orderFrontRegardless()
    }
}
