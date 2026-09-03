//
//  CalendarManager.swift
//  Late No More
//
//  Created by Manish Jain on 17/06/25.
//


import EventKit
import Foundation

let calendarManager = CalendarManager()

class CalendarManager {
    private let eventStore = EKEventStore()
    
    // MARK: - Authorization
    
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    func checkAuthorizationStatus() -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        return status == .authorized
    }
    
    // MARK: - Calendar Operations
    
    func fetchCalendar(named name: String, type: EKCalendarType) -> EKCalendar? {
        let calendars = eventStore.calendars(for: .event)
        return calendars.first { $0.title == name && $0.type == type }
    }
    
    func fetchCalendars(named names: [String] = [], types: [EKCalendarType] = []) -> [EKCalendar] {
        let allCalendars = eventStore.calendars(for: .event)
        
        if names.isEmpty && types.isEmpty {
            return allCalendars
        }
        
        return allCalendars.filter { calendar in
            let nameMatch = names.isEmpty || names.contains(calendar.title)
            let typeMatch = types.isEmpty || types.contains(calendar.type)
            return nameMatch && typeMatch
        }
    }
    
    // MARK: - Event Operations
    
    func fetchEvents(withUID uid: String) -> [EKEvent] {
        // First try to get the event directly by identifier
        if let event = eventStore.event(withIdentifier: uid) {
            return [event]
        }
        
        // If not found, search all events in a reasonable date range
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        let predicate = eventStore.predicateForEvents(
            withStart: oneYearAgo,
            end: oneYearFromNow,
            calendars: nil // search all calendars
        )
        
        let events = eventStore.events(matching: predicate)
        return events.filter { $0.calendarItemExternalIdentifier == uid }
                    .sorted { $0.startDate < $1.startDate }
    }
    
    func fetchEvents(from startDate: Date, to endDate: Date, in calendars: [EKCalendar]) -> [EKEvent] {
        // predicateForEvents raises NSInvalidArgumentException on an empty (non-nil) calendars
        // array ("An empty array is not allowed. Pass nil to search all calendars."). No enabled
        // calendars means there is nothing to check, so return early rather than crash.
        guard !calendars.isEmpty else { return [] }

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        return events.sorted { $0.startDate < $1.startDate }
    }
    
    func filterEvents(_ events: [EKEvent], title: String? = nil, location: String? = nil, description: String? = nil, hasAttendees: Bool? = nil, hasRecurrenceRules: Bool? = nil, isAllDay: Bool? = nil) -> [EKEvent] {
        return events.filter { event in
            let titleMatch = title == nil || event.title?.caseInsensitiveCompare(title!) == .orderedSame
            let locationMatch = location == nil || event.location?.caseInsensitiveCompare(location!) == .orderedSame
            let descriptionMatch = description == nil || (event.hasNotes && event.notes?.caseInsensitiveCompare(description!) == .orderedSame)
            let attendeesMatch = hasAttendees == nil || event.hasAttendees == hasAttendees!
            let recurrenceMatch = hasRecurrenceRules == nil || event.hasRecurrenceRules == hasRecurrenceRules!
            let allDayMatch = isAllDay == nil || event.isAllDay == isAllDay!
            
            return titleMatch && locationMatch && descriptionMatch && attendeesMatch && recurrenceMatch && allDayMatch
        }
    }
    
    func filterEventsByPattern(_ events: [EKEvent], titlePattern: String? = nil, descriptionPattern: String? = nil, locationPattern: String? = nil, useRegex: Bool = true) -> [EKEvent] {
        return events.filter { event in
            let titleMatch: Bool
            if let pattern = titlePattern {
                if useRegex {
                    titleMatch = event.title?.range(of: pattern, options: .regularExpression) != nil
                } else {
                    let wildcardPattern = pattern
                        .replacingOccurrences(of: "?", with: ".")
                        .replacingOccurrences(of: "*", with: ".*")
                    titleMatch = event.title?.range(of: wildcardPattern, options: .regularExpression) != nil
                }
            } else {
                titleMatch = true
            }
            
            let descriptionMatch: Bool
            if let pattern = descriptionPattern {
                if useRegex {
                    descriptionMatch = event.hasNotes && (event.notes?.range(of: pattern, options: .regularExpression) != nil)
                } else {
                    let wildcardPattern = pattern
                        .replacingOccurrences(of: "?", with: ".")
                        .replacingOccurrences(of: "*", with: ".*")
                    descriptionMatch = event.hasNotes && (event.notes?.range(of: wildcardPattern, options: .regularExpression) != nil)
                }
            } else {
                descriptionMatch = true
            }
            
            let locationMatch: Bool
            if let pattern = locationPattern {
                if useRegex {
                    locationMatch = event.location?.range(of: pattern, options: .regularExpression) != nil
                } else {
                    let wildcardPattern = pattern
                        .replacingOccurrences(of: "?", with: ".")
                        .replacingOccurrences(of: "*", with: ".*")
                    locationMatch = event.location?.range(of: wildcardPattern, options: .regularExpression) != nil
                }
            } else {
                locationMatch = true
            }
            
            return titleMatch && descriptionMatch && locationMatch
        }
    }
    
    func removeEvent(_ event: EKEvent, span: EKSpan = .futureEvents) throws {
        try eventStore.remove(event, span: span, commit: true)
    }
    
    func createEvent(in calendar: EKCalendar, title: String, startDate: Date, endDate: Date, isAllDay: Bool = false, location: String? = nil, description: String? = nil) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.location = location
        event.notes = description
        return event
    }
    
    func modifyEvent(_ event: EKEvent, calendar: EKCalendar? = nil, title: String? = nil, startDate: Date? = nil, endDate: Date? = nil, isAllDay: Bool? = nil, location: String? = nil, description: String? = nil) -> EKEvent {
        if let calendar = calendar { event.calendar = calendar }
        if let title = title { event.title = title }
        if let startDate = startDate { event.startDate = startDate }
        if let endDate = endDate { event.endDate = endDate }
        if let isAllDay = isAllDay { event.isAllDay = isAllDay }
        if let location = location { event.location = location }
        if let description = description { event.notes = description }
        return event
    }
    
}


