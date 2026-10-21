//
//  EventWarningManager.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//


import EventKit

class EventWarningManager {
    // MARK: - Properties
    private let calendarManager = CalendarManager()
    private var timer: Timer?
    private var shownWarnings: [String: Set<WarningTime>] = [:]
    private var arrCalendars: [[String: Any]] = []
    private var pickerStartTimeDateValue: Date!
    private var pickerEndTimeDateValue: Date!
    var timeInterval = 10
    /// When the previous check ran, so a warning whose moment fell between two checks is still shown.
    private var lastCheckDate: Date?
    // MARK: - Warning Times
    private enum WarningTime: String, CaseIterable {
        case fifteenMinutes = "15 minutes"
        case twoMinutes = "2 minutes"
//        case oneAndHalfMinutes = "1.5 minutes"
//        case oneMinute = "1 minute"
//        case thirtySeconds = "30 seconds"
        case eventTime = "event time"
        
        var timeInterval: TimeInterval {
            switch self {
            case .fifteenMinutes: return 900
            case .twoMinutes: return 120
//            case .oneAndHalfMinutes: return 90
//            case .oneMinute: return 60
//            case .thirtySeconds: return 30
            case .eventTime: return 0
            }
        }

        /// How late this warning may still be shown: until the next warning's moment (the start, for
        /// the two-minute one), and a minute for the start itself, when past events are cleaned up.
        var maximumLateness: TimeInterval {
            switch self {
            case .fifteenMinutes: return WarningTime.fifteenMinutes.timeInterval - WarningTime.twoMinutes.timeInterval
            case .twoMinutes: return WarningTime.twoMinutes.timeInterval
            case .eventTime: return WarningTiming.pastEventCleanupSeconds
            }
        }
    }
    
    // MARK: - Initialization
    func resetData(calendars: [[String: Any]], startTimePicker: NSDatePicker, endTimePicker: NSDatePicker) {
        self.arrCalendars = calendars
        self.pickerStartTimeDateValue = startTimePicker.dateValue
        self.pickerEndTimeDateValue = endTimePicker.dateValue
    }
    
    // MARK: - Public Methods
    func startCheck() {
        addLog(text: "func:- startCheck")
        stopCheck() // Stop any existing timer
        setupTimer()
    }
    
    func stopCheck() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private Methods
    private func setupTimer() {
        addLog(text: "func:- setupTimer checkEvents")
        // Run on background thread but add timer to main run loop
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.timer = Timer.scheduledTimer(
                timeInterval: TimeInterval(timeInterval),
                target: self,
                selector: #selector(self.checkEvents),
                userInfo: nil,
                repeats: true
            )
            
            RunLoop.current.add(self.timer!, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    @objc private func checkEvents() {
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
        
        let events = calendarManager.fetchEvents(from: startDateTime, to: endDateTime, in: calendarsToCheck)
        let currentDate = Date()
        let secondsSinceLastCheck = lastCheckDate.map { currentDate.timeIntervalSince($0) }
        defer { lastCheckDate = currentDate }
        
        for event in events where !event.isAllDay {
            if let startDateTime = event.startDate{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, d MMMM yyyy, h:mm a"

                let date = startDateTime // your date object
                let dateString = "Today, " + dateFormatter.string(from: date)
                let eventTitle = event.title ?? ""
                addLog(text: "event:- name: \(eventTitle), dateTime: \(dateString)")
                
                
                let eventId = event.eventIdentifier ?? UUID().uuidString
                var shownTimes = shownWarnings[eventId] ?? Set()
                
                let timeUntilEvent = startDateTime.timeIntervalSince(currentDate)
                
                for warningTime in WarningTime.allCases {
                    if WarningTiming.isDue(timeUntilEvent: timeUntilEvent, warningInterval: warningTime.timeInterval,
                                           secondsSinceLastCheck: secondsSinceLastCheck,
                                           tolerance: TimeInterval(timeInterval),
                                           maximumLateness: warningTime.maximumLateness) {
                        // Only show if we haven't shown this warning before
                        if !shownTimes.contains(warningTime) {
                            showWarnWindow(for: warningTime, event: event)
                            shownTimes.insert(warningTime)
                            shownWarnings[eventId] = shownTimes
                        }
                    }
                }
                // Cleanup past events
                if timeUntilEvent < -WarningTiming.pastEventCleanupSeconds {
                    shownWarnings.removeValue(forKey: eventId)
                }
            }
        }
        
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
    
    private func showWarnWindow(for warningTime: WarningTime, event: EKEvent) {
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

/// When a warning is due. It used to be due only when a check landed within `tolerance` of its exact
/// moment, so a check that ran late skipped it for good. On 21 Oct 2026 one 10-second check started at
/// 12:42:47 and stalled until 12:44:37 on a busy Mac; the 12:45 meeting's two-minute window
/// (12:42:50-12:43:10) fell inside the stall, so neither the alert nor Focus Bear's
/// event-about-to-start trigger was sent. A warning whose moment passed since the previous check is now
/// shown late, up to `maximumLateness`. The first check after launch still shows only on-time
/// warnings, so opening the app doesn't replay a meeting's earlier warnings.
enum WarningTiming {
    /// A started event's warnings are forgotten this long after its start.
    static let pastEventCleanupSeconds: TimeInterval = 60

    static func isDue(timeUntilEvent: TimeInterval, warningInterval: TimeInterval, secondsSinceLastCheck: TimeInterval?,
                      tolerance: TimeInterval, maximumLateness: TimeInterval) -> Bool {
        let lateness = warningInterval - timeUntilEvent
        guard lateness >= -tolerance else { return false }
        if lateness <= tolerance { return true }
        guard let secondsSinceLastCheck else { return false }
        return lateness <= secondsSinceLastCheck + tolerance && lateness <= maximumLateness
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
