const { add } = require('../events')

const { LOOK_AHEAD_MINUTES } = require('../..//config.js')

function addDummyEvent(
    summary,
    id,
    offset,
    location,
    url,
    description,
    type = 'default'
) {
    const startDate = new Date()
    startDate.setMinutes(startDate.getMinutes() + offset)
    const endDate = new Date()
    endDate.setMinutes(startDate.getMinutes() + offset + 1)

    console.log({ startDate, endDate })

    const evt = {
        summary,
        startDate,
        endDate,
        id,
        location,
        url,
        description,
        type,
    }
    console.log({ evt })

    console.log('Adding entry to upcomingEvents..')
    add('upcoming', evt)
}
function uuid() {
    return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (a) =>
        (a ^ ((Math.random() * 16) >> (a / 4))).toString(16)
    )
}
module.exports = async function addTestEvents() {
    console.log('In testing mode...')

    const waitFor = LOOK_AHEAD_MINUTES - 0.5
    addDummyEvent(
        'Event',
        uuid(),
        waitFor,
        'meeting room',
        'https://google.com'
    )
    // addDummyEvent("Event", "1", 15.25, "meeting room", "https://google.com");
}
