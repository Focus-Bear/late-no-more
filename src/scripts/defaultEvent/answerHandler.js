const setMeetingIntention = require('../intention.js')
const bark = require('../../bark.js')
const openMeetingURL = require('../../applescript/event.js')
const { MEETING_ACTION_BUTTONS } = require('../../../config.js')

async function attendMeeting(evt) {
    console.log('Opening meeting url, if present')
    if (evt?.url) {
        await openMeetingURL(evt.url)
        return
    }

    if (evt?.location?.startsWith('http')) {
        await openMeetingURL(evt.location)
    }
}
module.exports = async function handleAnswer(evt, answer) {
    const [truant, present] = MEETING_ACTION_BUTTONS
    if (!answer?.length) {
        console.log('no answer, continuing')
        throw { type: 'continue' }
    }

    bark.stop()

    if (answer == truant) {
        throw { type: 'break' }
    }

    if (answer == present) {
        await attendMeeting(evt)
        await setMeetingIntention(evt)
        throw { type: 'break' }
    }
}
