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
    private var warningIdentities: [String: SharedCalendarDismissals.Identity] = [:]
    private let warningLock = NSLock()
    private var arrCalendars: [[String: Any]] = []
    private var pickerStartTimeDateValue: Date!
    private var pickerEndTimeDateValue: Date!
    var timeInterval = 10
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
    }
    
    private var observesDismissals = false

    private func dismissalIdentity(_ event: EKEvent) -> SharedCalendarDismissals.Identity? {
        guard let eventID = event.eventIdentifier, let calendarID = event.calendar?.calendarIdentifier,
              let start = event.startDate else { return nil }
        return .init(eventID: eventID, calendarID: calendarID,
                     externalID: event.calendarItemExternalIdentifier, start: start, end: event.endDate)
    }

    @objc private func dismissalSnapshotChanged(_ notification: Notification) {
        // Notifications are only hints. Never accept a path or dismissal rules from the sender.
        DispatchQueue.main.async { self.closeHiddenAlerts() }
    }

    private func closeHiddenAlerts() {
        guard let snapshot = SharedCalendarDismissals.read() else { return }
        warningLock.lock()
        for (key, identity) in warningIdentities where snapshot.hides(identity) {
            shownWarnings.removeValue(forKey: key)
        }
        warningLock.unlock()
        for window in NSApplication.shared.windows {
            if let alert = window.contentViewController as? customAlertVc,
               let identity = alert.calendarDismissalIdentity, snapshot.hides(identity) {
                alert.silenceForCalendarDismissal()
            } else if let warning = window.contentViewController as? warnUserVc,
                      let identity = warning.calendarDismissalIdentity, snapshot.hides(identity) {
                window.close()
            }
        }
    }

    deinit { DistributedNotificationCenter.default().removeObserver(self) }

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
        if !observesDismissals {
            DistributedNotificationCenter.default().addObserver(self,
                selector: #selector(dismissalSnapshotChanged(_:)),
                name: NSNotification.Name(SharedCalendarDismissals.NOTIFICATION_NAME), object: nil)
            observesDismissals = true
        }
        DispatchQueue.main.async { self.closeHiddenAlerts() }
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
        let dismissals = SharedCalendarDismissals.read()
        DispatchQueue.main.async { self.closeHiddenAlerts() }
        
        for event in events where !event.isAllDay {
            if let identity = dismissalIdentity(event), dismissals?.hides(identity) == true { continue }
            if let startDateTime = event.startDate{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, d MMMM yyyy, h:mm a"

                let date = startDateTime // your date object
                let dateString = "Today, " + dateFormatter.string(from: date)
                let eventTitle = event.title ?? ""
                addLog(text: "event:- name: \(eventTitle), dateTime: \(dateString)")
                
                
                let eventId = (event.eventIdentifier ?? UUID().uuidString) + "|" + String(startDateTime.timeIntervalSince1970)
                warningLock.lock()
                if let identity = dismissalIdentity(event) { warningIdentities[eventId] = identity }
                var shownTimes = shownWarnings[eventId] ?? Set()
                warningLock.unlock()
                
                let timeUntilEvent = startDateTime.timeIntervalSince(currentDate)
                // Dealt with already, here or on another device (Focus Bear relays those): no more
                // warnings, no speech, and no Focus Bear trigger for it.
                // Not logged: this runs every few seconds per event, and the debug log already grows too fast.
                let isDismissed = MeetingDismissalRegistry.shared.isDismissed(MeetingIdentity(title: eventTitle, startDate: startDateTime))
                
                for warningTime in WarningTime.allCases where !isDismissed {
                    let warningInterval = warningTime.timeInterval
                    let timeDifference = timeUntilEvent - warningInterval
                    
                    // Check if we're within ±15 seconds of the warning time
                    if (0...timeInterval).contains(Int(abs(timeDifference))) {
                        // Only show if we haven't shown this warning before
                        if !shownTimes.contains(warningTime) {
                            showWarnWindow(for: warningTime, event: event)
                            shownTimes.insert(warningTime)
                            warningLock.lock()
                            shownWarnings[eventId] = shownTimes
                            warningLock.unlock()
                        }
                    }
                }
                // Cleanup past events
                if timeUntilEvent < -60 {
                    warningLock.lock()
                    shownWarnings.removeValue(forKey: eventId)
                    warningIdentities.removeValue(forKey: eventId)
                    warningLock.unlock()
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
        let identity = dismissalIdentity(event)
        DispatchQueue.main.async {
            if let identity, SharedCalendarDismissals.read()?.hides(identity) == true { return }
            let message: String
            switch warningTime {
            case .fifteenMinutes:
                message = "Event '\(event.title ?? "")' starts in 15 minutes"
                Late_No_More.showWarnWindow(title: event.title, calendarName: event.calendar.title, startDate: event.startDate, dismissalIdentity: identity)
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
                Late_No_More.showtCustomAlertWindow(title: event.title, time: event.startDate, url: eventUrl,notes: event.notes ?? "", eventId:eventId, dismissalIdentity: identity)
                
                
                let formatter = ISO8601DateFormatter()
                let isoStartDateString = formatter.string(from:event.startDate)
                let isoEndDateString = formatter.string(from:event.endDate)
                let eventTitle = event.title ?? ""
                let allowedCharacters = CharacterSet.urlQueryAllowed
                let encodedTitle = eventTitle.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
                let encodedStart = isoStartDateString.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
                let encodedEnd = isoEndDateString.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
                
                let focusBearAboutToStartUrl = "focusbear://event-about-to-start?event_title=\(encodedTitle)&event_start_time=\(encodedStart)&event_end_time=\(encodedEnd)"
                
                addLog(text: "Triggering FB event-about-to-start: \(focusBearAboutToStartUrl)")
                if let url = URL(string: focusBearAboutToStartUrl) {
                    NSWorkspace.shared.open(url)
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

// BEGIN SHARED CALENDAR DISMISSAL CONTRACT
// Keep byte-identical in Focus Bear and Late No More; synthetic fixtures check parity.
struct SharedCalendarDismissals: Codable {
    static let SCHEMA_VERSION = 1
    static let MAXIMUM_BYTES = 1_048_576
    static let MAXIMUM_RULES = 4096
    static let MAXIMUM_IDENTIFIER_LENGTH = 1024
    static let DIRECTORY_NAME = "FocusBearCalendarBridge"
    static let FILE_NAME = "dismissals-v1.json"
    static let NOTIFICATION_NAME = "io.focusbear.calendar-dismissals.changed.v1"
    static let REVISION_KEY = "revision"

    struct Identity: Codable, Equatable {
        let eventID: String
        let calendarID: String
        let externalID: String?
        let start: Date
        var end: Date? = nil
    }

    struct Rule: Codable, Equatable {
        enum Scope: String, Codable { case day, series }
        let eventID: String
        let calendarID: String
        let externalID: String?
        let scope: Scope
        let day: String?
        let timeZone: String?
        var occurrenceDay: String? = nil

        func matches(_ event: Identity) -> Bool {
            guard calendarID == event.calendarID else { return false }
            let sameEvent = eventID == event.eventID
            let sameExternal = externalID.map { !$0.isEmpty && $0 == event.externalID } ?? false
            guard sameEvent || sameExternal else { return false }
            guard scope == .day else { return true }
            guard let timeZone, let zone = TimeZone(identifier: timeZone) else { return false }
            guard occurrenceDay == SharedCalendarDismissals.dayKey(event.start, zone: zone),
                  let day else { return false }
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = zone
            formatter.dateFormat = "yyyy-MM-dd"
            guard let dayStart = formatter.date(from: day) else { return false }
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = zone
            guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else { return false }
            if let end = event.end, end > event.start {
                return event.start < dayEnd && end > dayStart
            }
            return event.start >= dayStart && event.start < dayEnd
        }
    }

    let version: Int
    let revision: UUID
    let accountID: String
    var rules: [Rule]

    static func dayKey(_ date: Date, zone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = zone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func rule(event: Identity, day: Date?, zone: TimeZone) -> Rule {
        Rule(eventID: event.eventID, calendarID: event.calendarID, externalID: event.externalID,
             scope: day == nil ? .series : .day,
             day: day.map { dayKey($0, zone: zone) }, timeZone: day == nil ? nil : zone.identifier,
             occurrenceDay: day == nil ? nil : dayKey(event.start, zone: zone))
    }

    var isValid: Bool {
        func validID(_ value: String) -> Bool { !value.isEmpty && value.utf8.count <= Self.MAXIMUM_IDENTIFIER_LENGTH }
        guard version == Self.SCHEMA_VERSION, accountID.utf8.count <= Self.MAXIMUM_IDENTIFIER_LENGTH,
              rules.count <= Self.MAXIMUM_RULES, !accountID.isEmpty || rules.isEmpty else { return false }
        return rules.allSatisfy { rule in
            guard validID(rule.eventID), validID(rule.calendarID),
                  rule.externalID.map({ validID($0) }) ?? true else { return false }
            switch rule.scope {
            case .series: return rule.day == nil && rule.timeZone == nil && rule.occurrenceDay == nil
            case .day:
                guard let day = rule.day, day.count == 10,
                      day.range(of: #"^\d{4}-\d{2}-\d{2}$"#, options: .regularExpression) != nil,
                      let zone = rule.timeZone, TimeZone(identifier: zone) != nil else { return false }
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(identifier: zone)
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.isLenient = false
                guard let date = formatter.date(from: day) else { return false }
                guard formatter.string(from: date) == day, let occurrenceDay = rule.occurrenceDay,
                      occurrenceDay.count == 10, let occurrence = formatter.date(from: occurrenceDay) else { return false }
                return formatter.string(from: occurrence) == occurrenceDay
            }
        }
    }

    func hides(_ event: Identity) -> Bool { isValid && rules.contains { $0.matches(event) } }

    static func decode(_ data: Data) -> Self? {
        guard data.count <= MAXIMUM_BYTES, let value = try? JSONDecoder().decode(Self.self, from: data),
              value.isValid else { return nil }
        return value
    }

    static var fileURL: URL {
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support", isDirectory: true)
            .appendingPathComponent(DIRECTORY_NAME, isDirectory: true).appendingPathComponent(FILE_NAME)
    }

    static func read(at url: URL = fileURL) -> Self? {
        let url = URL(fileURLWithPath: url.path)
        let directory = url.deletingLastPathComponent()
        guard let parent = try? directory.resourceValues(forKeys: [.isSymbolicLinkKey]), parent.isSymbolicLink != true,
              let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey, .fileSizeKey]),
              values.isRegularFile == true, values.isSymbolicLink != true,
              let size = values.fileSize, size <= MAXIMUM_BYTES,
              let handle = try? FileHandle(forReadingFrom: url) else { return nil }
        defer { try? handle.close() }
        guard let data = try? handle.read(upToCount: MAXIMUM_BYTES + 1) else { return nil }
        return decode(data)
    }

    func write(at url: URL = Self.fileURL) throws {
        guard isValid else { throw CocoaError(.fileWriteInvalidFileName) }
        let data = try JSONEncoder().encode(self)
        guard data.count <= Self.MAXIMUM_BYTES else { throw CocoaError(.fileWriteOutOfSpace) }
        let url = URL(fileURLWithPath: url.path)
        let directory = url.deletingLastPathComponent()
        let manager = FileManager.default
        if manager.fileExists(atPath: directory.path),
           try directory.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink == true {
            throw CocoaError(.fileWriteNoPermission)
        }
        if manager.fileExists(atPath: url.path),
           try url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink == true {
            throw CocoaError(.fileWriteNoPermission)
        }
        try manager.createDirectory(at: directory, withIntermediateDirectories: true,
                                    attributes: [.posixPermissions: 0o700])
        try manager.setAttributes([.posixPermissions: 0o700], ofItemAtPath: directory.path)
        try data.write(to: url, options: .atomic)
        try manager.setAttributes([.posixPermissions: 0o600], ofItemAtPath: url.path)
    }
}
// END SHARED CALENDAR DISMISSAL CONTRACT
