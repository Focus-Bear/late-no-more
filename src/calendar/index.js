const exec = require('../applescript/exec.js'),
    { GET_ALL_EVENTS, SCRIPT_HEADER } = require('../applescript/scripts.js')

const { logToFile } = require('../util/log-message.js')

const { tidyEvent } = require('../calendar/tidy.js')

let EVENTS_TO_EXCLUDE, CALENDARS_TO_EXCLUDE

function ignoreByCalendar(calendarName) {
    const shouldIgnoreCalendar = CALENDARS_TO_EXCLUDE.some(
        (calendarToExclude) => {
            return calendarName
                ?.toLowerCase()
                ?.includes(calendarToExclude?.toLowerCase())
        }
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

async function setCalsToExclude(calList) {
    logToFile('setting CALENDARS_TO_EXCLUDE', calList)
    CALENDARS_TO_EXCLUDE = calList?.map((calendar) => calendar.name) || []
}

async function setEventsToExclude(eventList) {
    logToFile('setting EVENTS_TO_EXCLUDE', eventList)
    EVENTS_TO_EXCLUDE = eventList
}

function filterEvent({ calendarName, summary }) {
    try {
        ignoreByCalendar(calendarName)
        ignoreByEvent(summary)

        return true
    } catch (e) {
        if (!e.message.includes('Ignoring')) {
            logToFile('Error in filterEvent', e.message)
        }
        return false
    }
}

async function getEvents() {
    const rawEvents = await exec(SCRIPT_HEADER + GET_ALL_EVENTS),
        withOutBlanks = rawEvents.filter((e) => e.length),
        tidied = withOutBlanks.map(tidyEvent)
    return tidied.filter(filterEvent)
}
module.exports = {
    getEvents,
    setCalsToExclude,
    setEventsToExclude,
}
