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
let barkingStartTime = null
const MAX_BARKING_DURATION_MS = 5 * 60 * 1000

module.exports = async function handleAnswer(evt, answer) {
    const [truant, present] = MEETING_ACTION_BUTTONS
    if (!answer?.length) {
        logToFile(`📭 no answer, let's escalate..`)
        if (barkingTimeout) clearTimeout(barkingTimeout)

        const now = Date.now()
        if (!barkingStartTime) {
            barkingStartTime = now
        }

        const elapsedTime = now - barkingStartTime
        if (elapsedTime >= MAX_BARKING_DURATION_MS) {
            logToFile(
                'Max barking duration (5 minutes) reached, stopping barking'
            )
            bark.stop()
            barkingStartTime = null
            throw { type: 'continue' }
        }

        const remainingTime = MAX_BARKING_DURATION_MS - elapsedTime
        logToFile(
            `setting bark timeout for ${Math.round(remainingTime / 1000)}s remaining..`
        )
        barkingTimeout = setTimeout(() => {
            logToFile('timeout ending the barking after 5 minutes max')
            bark.stop()
            barkingStartTime = null
        }, remainingTime)
        throw { type: 'continue' }
    }

    logToFile(`🗯️  The user answers "${answer}"`)
    bark.stop()
    barkingStartTime = null
    if (barkingTimeout) {
        clearTimeout(barkingTimeout)
        barkingTimeout = false
    }

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
