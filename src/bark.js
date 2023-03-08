const say = require('./applescript/say.js')
const { readSettings } = require('./applescript/fs.js')

const {
    DIALOG_STAGES,
    VERBAL_ALERTS,
    MEETING_QUESTIONS,
    MEETING_ACTION_BUTTONS,
    PAUSE_BETWEEN_BARKS_SECONDS,
    LOOK_AHEAD_MINUTES,
} = require('../config.js')

let barking = false,
    barkTime = null

async function setBarkTime() {
    const { barkStartTime, barkEndTime } = await readSettings()
    barkTime = { startTime: barkStartTime, endTime: barkEndTime }

    console.log({ barkTime })
}
setBarkTime()

function checkIfBarkTime() {
    const [startHr, startMin] = barkTime.startTime.split(':')
    const [endHr, endMin] = barkTime.endTime.split(':')

    const startAt = new Date()
    startAt.setHours(startHr)
    startAt.setMinutes(startMin)

    const endAt = new Date()
    endAt.setHours(endHr)
    endAt.setMinutes(endMin)

    const rn = new Date(Date.now())

    return rn >= startAt && rn <= endAt
}

function startBarking(evt) {
    console.log('Starting barks...')
    const pauseFor = PAUSE_BETWEEN_BARKS_SECONDS * 1000

    if (barking) {
        // avoid multiple barks
        clearInterval(barking)
    }

    barking = setInterval(async () => {
        console.log('In barking interval...')
        const shouldBark = checkIfBarkTime()
        if (!shouldBark) {
            stopBarking()
            return
        }
        const randomIndex = Math.floor(Math.random() * VERBAL_ALERTS.length),
            dialog = VERBAL_ALERTS[randomIndex],
            preamble = "Meeting, '" + evt.summary + "'.",
            toSay = preamble + dialog

        await say(toSay)
    }, pauseFor)
}

function stopBarking() {
    console.log('Silencing barks')
    clearInterval(barking)
    barking = false
}

function getState() {
    return barking
}

module.exports = {
    start: startBarking,
    stop: stopBarking,
    getState,
}
