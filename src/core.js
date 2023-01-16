const events = require('./events/index.js')
const { getEvents } = require('./calendar')
const scriptIndex = require('./events/scripts/')

async function checkUpcoming() {
    const { upcoming, expired } = events.get()
    if (!upcoming?.length) {
        return
    }

    const { length: count } = upcoming,
        now = new Date()

    const s = count > 1 ? 's' : ''
    console.log(`Waiting on ${count} upcoming event${s}`)

    for (let i = 0; i < upcoming.length; i++) {
        const evt = upcoming[i],
            eventHandler = scriptIndex[evt.type]

        await eventHandler(evt, now)
    }

    if (expired.length) {
        console.log('removing expired event(s) from upcoming list')
        const update = upcoming.filter((evt) => !expired.includes(evt.uid))
        events.set('upcoming', update)
    }
}

async function checkCalendars() {
    const { expired } = events.get(),
        newEvents = await getEvents(),
        update = newEvents.filter(
            (e) => !expired.map(({ id }) => id).includes(e?.id)
        )

    events.set('upcoming', update)
    console.log(`Found ${update.length} upcoming events`)
}
module.exports = { checkUpcoming, checkCalendars }
