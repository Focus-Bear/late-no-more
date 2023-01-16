const { add } = require('../events')

const { LOOK_AHEAD_MINUTES } = require('../../config.js')

function addDummyEvent(
    summary,
    uid,
    offset,
    location,
    url,
    description,
    type = 'default'
) {
    const startDate = new Date()
    startDate.setMinutes(startDate.getMinutes() + offset)

//    type = 'meetingEnd'
    const intention = 'stay awake'

    const evt = {
        summary,
        startDate,
        uid,
        location,
        url,
        description,
        intention,
        type,
    }

    console.log('Adding entry to upcomingEvents..')
    add('upcoming', evt)
}

module.exports = async function addTestEvents() {
    console.log('In testing mode...')

    const waitFor = LOOK_AHEAD_MINUTES - 0.5
    addDummyEvent('Event', '1', waitFor, 'meeting room', 'https://google.com')
    // addDummyEvent("Event", "1", 15.25, "meeting room", "https://google.com");
}
