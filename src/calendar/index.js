const exec = require('../applescript/exec.js'),
    { GET_ALL_EVENTS, SCRIPT_HEADER } = require('../applescript/scripts.js')

let EVENTS_TO_EXCLUDE, CALENDARS_TO_EXCLUDE

async function setCalsToExclude(calList) {
    console.log('setting CALENDARS_TO_EXCLUDE', calList)
    CALENDARS_TO_EXCLUDE = calList
}
async function setEventsToExclude(eventList) {
    console.log('setting EVENTS_TO_EXCLUDE', eventList)
    EVENTS_TO_EXCLUDE = eventList
}

async function getCalendars() {
    return await exec(allCalendars)
}

function tidyDate(date) {
    return new Date(date.split(',').slice(1).join(',').replace(' at', ''))
}

function matchServices(evt) {
    const { description } = evt

    const isGoogleMeet = description?.includes('google.com'),
        isMsftTeams = description?.includes('microsoft.com')

    if (isMsftTeams || isGoogleMeet) {
        const regex = /https\S*[\s\>]/,
            [url] = description.match(regex)
        return { ...evt, url: url.trim() }
    }
    return evt
}

function tidyEvent(evt, type = 'default') {
    const tidy = evt.map((field) => {
        if (field == 'missing value') return null
        return field
    })

    const [summary, start, end, url, loc, desc, id, calName] = tidy

    const obj = {
        summary,
        calendarName: calName,
        startDate: tidyDate(start),
        endDate: tidyDate(end),
        location: loc,
        description: desc,
        url,
        type,
        id,
    }
    return matchServices(obj)
}

function filterArray(sourceList, filterBy, key) {
    return sourceList.filter((entry) => filterBy.includes(entry[key]))
}

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
    matchServices,
}
