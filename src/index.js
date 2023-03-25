const scriptIndex = require('./scripts')
const events = require('./events')
const { getEvents } = require('./calendar')

function prune() {
    const { active, upcoming, looming } = events.get()
    const all = { active, looming, upcoming }

    console.log('🍃 Pruning...')

    const expiry = new Date(Date.now())

    for (const listName in all) {
        const current = all[listName]

        for (const evt of current) {
            if (expiry < evt.endDate) continue
            events.remove(listName, evt, '🪦 Expired')
        }
    }
}

function pluralize(word, count) {
    const s = count == 1 ? '' : 's'
    return word + s
}

module.exports = async function update() {
    console.log('⏱️  Running core loop', new Date())
    const { looming, upcoming, active } = events.get()
    const calendarEvents = await getEvents()

    //    console.log({ active, looming, upcoming, calendarEvents })

    const filtered = events.filter(['active'], [...calendarEvents, ...upcoming])
    // We take the events straight out of applescript,
    // and combine them with our list of internally
    // generated & tracked events (eg, intention follow up)

    const { length: count } = filtered

    console.log(`🔎 Events left after filtering: ${filtered.length}`)
    if (!filtered.length) return

    console.log(`🗓️  ${filtered.length} upcoming ${pluralize('event', count)}`)

    const now = new Date()
    for (const evt of filtered) {
        const eventHandler = scriptIndex[evt.type]
        console.log('🎬 Starting eventHandler')
        await eventHandler(evt, now)
        console.log('✅ eventHandlerFinished')
    }

    prune()
    console.log('\n')
}
