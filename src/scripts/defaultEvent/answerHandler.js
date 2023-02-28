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
function extractLine(str) {
    const lines = str.split('\n')
    if (!lines?.length) return str

    const [hit] = lines.filter((x) => x.includes('fbtrigger:'))

    const [final] = hit.trim().split(':').reverse()
    return final
}

function checkForTrigger(evt) {
    const { summary, description } = evt

    const toLookAt = [summary, description]

    for (const str of toLookAt) {
        if (!str.includes('fbtrigger:')) {
            continue
        }
        const trigger = extractLine(str)
        console.log({ trigger })
        return trigger
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
        checkForTrigger(evt)
        await attendMeeting(evt)
        await setMeetingIntention(evt)
        throw { type: 'break' }
    }
}
