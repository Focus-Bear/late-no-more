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
<<<<<<< HEAD
    console.log(`Adding ${evt.type} type event "${evt.summary}" to ${listName}`, evt)
=======
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    const theList = events[listName]
    events[listName] = [...theList, evt]
}

function remove(listName, evt) {
<<<<<<< HEAD
    console.log(`Removing ${evt.type} type event "${evt.summary}" from ${listName}`, evt)
=======
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    const theList = events[listName]
    
    events[listName] = theList.filter(
        ({ id, type }) => evt.id !== id && evt.type !== type
    )
}

function has(listName, evt){
    return !!events[listName].filter(({id, type})=> id == evt.id && type == evt.type)?.length
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
