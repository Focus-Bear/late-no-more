const { getEvents } = require('./calendar')
const scriptIndex = require('./scripts')
const prune = require('./prune.js')
const events = require('./events')

async function checkUpcoming() {
    prune()
    const { upcoming, active, looming } = events.get()
    console.log(JSON.stringify({ upcoming, looming, active }, null, 2))
    if (!upcoming?.length) {
        return
    }

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
}

async function checkCalendars() {
    const newEvents = await getEvents()

    events.set('upcoming', newEvents)
    console.log(`🗓️ Found ${newEvents.length} upcoming events`)
}
module.exports = { checkUpcoming, checkCalendars }
