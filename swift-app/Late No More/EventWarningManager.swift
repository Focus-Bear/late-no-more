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

        // Never alert outside the user's configured bark hours. The fetch window below is an
        // overlap query, so an event starting before barkStartTime but ending after it (e.g. a
        // 5:40am run that ends past a 6:00am start) still gets pulled in — and its warnings fire
        // relative to the event start, well before the window. Gate on the current clock time so
        // no popup or verbal alert happens before barkStartTime or after barkEndTime.
        guard isWithinBarkHours(start: startDateTime, end: endDateTime) else {
            addLog(text: "func:- checkEvents skipped: outside bark hours")
            return
        }

        let events = calendarManager.fetchEvents(from: startDateTime, to: endDateTime, in: calendarsToCheck)
        let currentDate = Date()
        
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
                    let warningInterval = warningTime.timeInterval
                    let timeDifference = timeUntilEvent - warningInterval
                    
                    // Check if we're within ±15 seconds of the warning time
                    if (0...timeInterval).contains(Int(abs(timeDifference))) {
                        // Only show if we haven't shown this warning before
                        if !shownTimes.contains(warningTime) {
                            showWarnWindow(for: warningTime, event: event)
                            shownTimes.insert(warningTime)
                            shownWarnings[eventId] = shownTimes
                        }
                    }
                }
                // Cleanup past events
                if timeUntilEvent < -60 {
                    shownWarnings.removeValue(forKey: eventId)
                }
            }
        }
        
    }
    
    private func isWithinBarkHours(start: Date, end: Date) -> Bool {
        let now = Date()
        return now >= start && now <= end
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
