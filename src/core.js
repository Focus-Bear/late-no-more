const events = require('./events')
const { getEvents } = require('./calendar')
const scriptIndex = require('./scripts')

async function checkUpcoming() {
    const { upcoming } = events.get()
    if (!upcoming?.length) {
        return
    }
    console.log({ upcoming })
    const { length: count } = upcoming,
        now = new Date()

    const s = count > 1 ? 's' : ''
    console.log(`⏳ Waiting on ${count} upcoming event${s}`)

    for (let i = 0; i < upcoming.length; i++) {
        const evt = upcoming[i],
            eventHandler = scriptIndex[evt.type]
        await eventHandler(evt, now)
    }
}

async function checkCalendars() {
    const newEvents = await getEvents()

    events.set('upcoming', newEvents)
    console.log(`🗓️ Found ${newEvents.length} upcoming events`)
}
module.exports = { checkUpcoming, checkCalendars }
