const setMeetingIntention = require('../intention.js')
const bark = require('../../bark.js')
const open = require('../../applescript/open.js')
const openMeetingURL = require('../../applescript/event.js')
const { MEETING_ACTION_BUTTONS } = require('../../../config.js')

async function attendMeeting(evt) {
    if (evt?.url) {
        console.log(`📄 Opening ${evt.url}`)
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
        return trigger
    }
    return false
}
function getEventDuration(event) {
    const startDate = new Date(event.startDate)
    const endDate = new Date(event.endDate)
    const duration = (endDate.getTime() - startDate.getTime()) / 1000 / 60
    return duration
}

function handleTrigger(evt, trigger) {
    console.log(`📍 Found trigger "${trigger}", opening...`)
    const duration = getEventDuration(evt)
    const url = `focusbear://start-activity?activity_id=${trigger}&duration_seconds=${duration}`
    open(url)
}

module.exports = async function handleAnswer(evt, answer) {
    const [truant, present] = MEETING_ACTION_BUTTONS
    if (!answer?.length) {
        console.log(`📭 no answer, let's escalate..`)
        throw { type: 'continue' }
    }

    console.log(`🗯️ The user answers "${answer}"`)
    bark.stop()

    if (answer == truant) {
        throw { type: 'break' }
    }

    if (answer == present) {
        const trigger = checkForTrigger(evt)
        if (trigger) handleTrigger(evt, trigger)
        await attendMeeting(evt)
        await setMeetingIntention(evt)
        throw { type: 'break' }
    }
}
