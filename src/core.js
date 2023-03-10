const { LOOK_AHEAD_MINUTES } = require('../config.js')
const events = require('./events')
const { getEvents } = require('./calendar')
const scriptIndex = require('./scripts')

function prune() {
    const { active, upcoming, looming } = events.get()

    const expiry = new Date(Date.now())
    const currMin = expiry.getMinutes()
    expiry.setMinutes(currMin + LOOK_AHEAD_MINUTES + 1)

    const all = { active, looming, upcoming }

    for (const listName in all) {
        for (const evt of active) {
					console.log({listName, evt, expiry})
            if (expiry > evt.startDate) continue
            console.log('Pruning old event', listName, evt)
            events.remove(listName, evt)
        }
    }
}

async function checkUpcoming() {
    const { upcoming, active, looming } = events.get()
    console.log(JSON.stringify({ upcoming, looming, active }, null, 2))
    if (!upcoming?.length) {
        return
    }
    //console.log({ upcoming })
    const { length: count } = upcoming,
        now = new Date()

    const s = count > 1 ? 's' : ''
    console.log(`⏳ Waiting on ${count} upcoming event${s}`)

    for (let i = 0; i < upcoming.length; i++) {
        const evt = upcoming[i]
        const eventHandler = scriptIndex[evt.type]

        const isActive = events.has('active', evt)
        console.log({ isActive, evt })

        await eventHandler(evt, now)
    }
    prune()
}

async function checkCalendars() {
    const newEvents = await getEvents()

    events.set('upcoming', newEvents)
    console.log(`🗓️ Found ${newEvents.length} upcoming events`)
}
module.exports = { checkUpcoming, checkCalendars }
