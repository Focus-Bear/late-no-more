const scriptIndex = require('../scripts')
const { LOOK_AHEAD_MINUTES } = require('../../config.js')

const events = {
    upcoming: [],
    expired: [],
    looming: [],
    active: [],
}

function set(listName, evts) {
    events[listName] = evts
}

function add(listName, evt) {
    console.log(`✅ Adding ${evt.type} "${evt.summary}" to "${listName}"`)
    const theList = events[listName]
    events[listName] = [...theList, evt]
}

function remove(listName, evt, reason) {
    if (!has(listName, evt)) return

    const theList = events[listName]

    events[listName] = theList.filter(
        ({ id, type }) => evt.id !== id && evt.type !== type
    )

    console.log(`🚮 Removing ${evt.type} "${evt.summary}" from "${listName}"`)
    if (reason) console.log(' - Reason given', reason)
}

function has(listName, evt) {
    return !!events[listName].filter(
        ({ id, name, type }) =>
            (id == evt.id || name === evt.name) && type == evt.type
    )?.length
}

function get(listName) {
    if (!listName) return events
    return events[listName]
}

function filter(lists, events) {
    const filteredEvents = []

    console.log({ lists, events })
    for (const evt of events) {
        const isKnown = lists.some((listName) => has(listName, evt))
        console.log({ evt, isKnown })
        if (isKnown) {
            continue
        }

        filteredEvents.push(evt)
    }
    return filteredEvents
}

module.exports = {
    set,
    add,
    remove,
    get,
    has,
    filter,
}
