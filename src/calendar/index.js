const exec = require('../applescript/exec.js'),
    { GET_ALL_EVENTS, SCRIPT_HEADER } = require('../applescript/scripts.js')

const { tidyEvent } = require('./tidy.js'),
    { ignoreByEvent, ignoreByCalendar } = require('./filters.js')

let EVENTS_TO_EXCLUDE, CALENDARS_TO_EXCLUDE

async function setCalsToExclude(calList) {
    console.log('setting CALENDARS_TO_EXCLUDE', calList)
    CALENDARS_TO_EXCLUDE = calList
}

async function setEventsToExclude(eventList) {
    console.log('setting EVENTS_TO_EXCLUDE', eventList)
    EVENTS_TO_EXCLUDE = eventList
}

function filterEvent({ calendarName, summary }) {
    try {
        ignoreByCalendar(calendarName)
        ignoreByEvent(summary)

        return true
    } catch (e) {
        console.log(e.message)
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
