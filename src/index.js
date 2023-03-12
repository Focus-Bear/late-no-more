const scriptIndex = require('./scripts')
const events = require('./events')
const { getEvents } = require('./calendar')

function prune() {
    const { active, upcoming, looming } = events.get()
    const all = { active, looming, upcoming }

    const expiry = new Date(Date.now())

    for (const listName in all) {
        const current = all[listName]

        for (const evt of current) {
            if (expiry < evt.endDate) continue
            events.remove(listName, evt, 'Expired')
        }
    }
}

function pluralize(word, count) {
    const s = count == 1 ? '' : 's'
    return word + s
}

module.exports = async function update() {
    const { looming, upcoming } = events.get()
    const calendarEvents = await getEvents()

    const filtered = events.filter(
        ['active', 'looming'],
        [...calendarEvents, ...upcoming, ...looming]
    )
    const { length: count } = filtered

    if (!filtered.length) return

    console.log(`🗓️  ${filtered.length} upcoming ${pluralize('event', count)}`)

    const now = new Date()
    for (const evt of filtered) {
        const eventHandler = scriptIndex[evt.type]
        await eventHandler(evt, now)
    }

    prune()
}
