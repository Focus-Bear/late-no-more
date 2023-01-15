function ignoreByCalendar(calendarName) {
    const shouldIgnoreCalendar = CALENDARS_TO_EXCLUDE.some(
        (calendarToExclude) =>
            calendarName
                ?.toLowerCase()
                ?.includes(calendarToExclude?.toLowerCase())
    )

    if (shouldIgnoreCalendar)
        throw { message: `Ignoring calendar '${calendarName}'` }
}

function ignoreByEvent(summary) {
    const shouldIgnoreEvent = EVENTS_TO_EXCLUDE.some((eventToExclude) =>
        summary?.toLowerCase()?.includes(eventToExclude?.toLowerCase())
    )

    if (shouldIgnoreEvent) throw { message: `Ignoring Event '${summary}'` }
}

module.exports = { ignoreByEvent, ignoreByCalendar }
