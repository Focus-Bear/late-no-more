const { logToFile } = require('../util/log-message')

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
    logToFile(`✅ Adding ${evt.type} "${evt.summary}" to "${listName}"`)
    remove(listName, evt)
    const theList = events[listName]
    events[listName] = [...theList, evt]
}

function remove(listName, evt, reason) {
    if (!has(listName, evt)) return

    const theList = events[listName]

    events[listName] = theList.filter(
        ({ id, type }) => evt.id !== id && evt.type !== type
    )

    logToFile(
        `🚮 Removing ${evt.type.toUpperCase()} "${
            evt.summary
        }" from "${listName}"`
    )
    if (reason) logToFile(` ↳ Reason given "${reason}"`)
}

function has(listName, evt) {
    return !!events[listName].filter(
        ({ id, type }) => id == evt.id && type == evt.type
    )?.length
}

function get(listName) {
    if (!listName) return events
    return events[listName]
}

function filter(lists, events) {
    const filteredEvents = []

    for (const evt of events) {
        const isKnown = lists.some((listName) => has(listName, evt))
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
