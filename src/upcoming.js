const { notifyUser, warnUser, calculateProximity } = require('./notify.js')
const { getEvents } = require('./calendar.js')

let upcomingEvents = [],
    expired = [],
    looming = [];

function setUpcoming(evts) {
    upcomingEvents = evts
}

function addEvent(evt) {
    upcomingEvents = [...upcomingEvents, evt]
}

async function removeEvent(evt) {
    expired.push(evt)
    looming = looming.filter(id => evt?.id !== id)
    upcomingEvents = upcomingEvents.filter(({ id }) => evt?.id !== id)
}

async function syncCalendarsToUpcoming() {
    const events = await getEvents()
    upcomingEvents = events.filter(
        (e) => !expired.map(({ id }) => id).includes(e?.id)
    )

    console.log(`Found ${upcomingEvents.length} upcoming events`)
}

async function checkUpcomingForMeetings() {
    if (!upcomingEvents?.length) {
        return
    }

    const { length: count } = upcomingEvents,
        now = new Date()

    console.log(
        `Waiting on ${count} upcoming event${count > 1 ? 's' : ''}`,
        JSON.stringify(upcomingEvents)
    )

    for (let i = 0; i < upcomingEvents.length; i++) {
        const evt = upcomingEvents[i],
            { delta, imminent, soon } = calculateProximity(evt, now)


        if (soon && !looming.includes(evt?.id)) {
            looming.push(evt?.id)
            warnUser(evt)
        }

        if (delta && imminent) {
            removeEvent(evt)
            notifyUser(evt)
        }

        // Super late now - stop hassling them
        if (delta <= -10) {
            console.log('Delta', delta, evt)
            expired.push(evt.uid)
        }
    }

    if (expired.length) {
        console.log('Removing expired event(s) from upcomingEvents list')
        upcomingEvents = upcomingEvents.filter(
            (evt) => !expired.includes(evt.uid)
        )
    }
}
module.exports = {
    addEvent,
    removeEvent,
    setUpcoming,
    upcomingEvents,
    checkUpcomingForMeetings,
    syncCalendarsToUpcoming,
}
