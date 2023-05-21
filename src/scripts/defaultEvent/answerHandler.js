const setMeetingIntention = require('../intention.js')
const bark = require('../../bark/index.js')
const handleTrigger = require('./fbTrigger.js')
const openMeetingURL = require('../../applescript/event.js')
const { logToFile } = require('../../util/log-message.js')
const { MEETING_ACTION_BUTTONS } = require('../../../config.js')

async function attendMeeting(evt) {
    if (evt?.url) {
        logToFile(`📄 Opening ${evt.url}`)
        await openMeetingURL(evt.url)
        return
    }

    if (evt?.location?.startsWith('http')) {
        await openMeetingURL(evt.location)
    }
}

let barkingTimeout = false

module.exports = async function handleAnswer(evt, answer) {
    const [truant, present] = MEETING_ACTION_BUTTONS
    if (!answer?.length) {
        logToFile(`📭 no answer, let's escalate..`)
        if (barkingTimeout) clearTimeout(barkingTimeout)

        logToFile('setting bark timeout..')
        barkingTimeout = setTimeout(() => {
            logToFile('timeout ending the barking')
            bark.stop()
        }, 15 * 60 * 1000)
        throw { type: 'continue' }
    }

    logToFile(`🗯️  The user answers "${answer}"`)
    bark.stop()

    if (answer == truant) {
        throw { type: 'break' }
    }

    if (answer == present) {
        handleTrigger(evt)
        await attendMeeting(evt)
        await setMeetingIntention(evt)
        throw { type: 'break' }
    }
}
