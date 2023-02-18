const scriptIndex = require('../scripts')
const { LOOK_AHEAD_MINUTES } = require('../../config.js')

const events = {
    upcoming: [],
    expired: [],
    looming: [],
}

function set(listName, evts) {
    events[listName] = evts
}

function add(listName, evt) {
    console.log(`Adding ${evt.type} type event "${evt.summary}" to ${listName}`, evt)
    const theList = events[listName]
    events[listName] = [...theList, evt]
}

function remove(listName, evt) {
    console.log(`Removing ${evt.type} type event "${evt.summary}" from ${listName}`, evt)
    const theList = events[listName]
    
    events[listName] = theList.filter(
        ({ id, type }) => evt.id !== id && evt.type !== type
    )
}

function has(listName, evt){
    return !!events[listName].filter(({id, name, type})=> (id == evt.id || name === evt.name) && type == evt.type)?.length
}

function get(listName) {
    if (!listName) return events
    return events[listName]
}

module.exports = {
    set,
    add,
    remove,
    get,
    has
}
