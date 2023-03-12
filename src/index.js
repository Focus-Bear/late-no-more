// what's the state of everything?

// am I barking?
// am I displaying any popups? (do i need this?)

// lets check the calendar

// ok, got everything, now lets filter it:
// filter out based on presets (or is that done at the point of consumption?)
// all events => filter by existing
// if it's active or looming, delete it (well, replace with new one)
// otherwise, clear the upcoming list and replace it with what's late

// what's active RIGHT if anything?
// what's looming?
// what's upcoming?
const scriptIndex = require('./scripts')
const events = require('./events')
const { getEvents } = require('./calendar')

function prune() {
    console.log('Pruning lists..')
    const { active, upcoming, looming } = events.get()
    const all = { active, looming, upcoming }

    const expiry = new Date(Date.now())

    for (const listName in all) {
        const current = all[listName]

        for (const evt of current) {
            if (expiry < evt.endDate) continue
            console.log('Pruning old event', listName, evt)
            events.remove(listName, evt, 'Expired')
        }
    }
}

function pluralize(word, count) {
    const s = count == 1 ? '' : 's'
    return word + s
}

module.exports = async function update() {
    prune()

    const { upcoming } = events.get('upcoming')
    const calendarEvents = await getEvents()

    const toInspect = []

    if (upcoming?.length) toInspect.push(...upcoming)
    if (calendarEvents?.length) toInspect.push(...calendarEvents)

    const filtered = events.filter(['active', 'looming'], toInspect),
        { length: count } = filtered

    if (!filtered.length) return

    console.log(`🗓️  ${filtered.length} upcoming ${pluralize('event', count)}`)

    const now = new Date()
    for (const evt of filtered) {
        const eventHandler = scriptIndex[evt.type]
        await eventHandler(evt, now)
    }
}
