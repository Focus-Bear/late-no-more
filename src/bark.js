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
    console.log(`📙 Allowed to bark ${barkStartTime}-${barkEndTime}`)
}
setBarkTime()

function isBarkTime() {
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
    console.log('🐕 Barking requested!')
    const pauseFor = PAUSE_BETWEEN_BARKS_SECONDS * 1000

    if (barking) {
        // prevents bark overlap
        clearInterval(barking)
    }

    barking = setInterval(async () => {
        console.log('🐶 Preparing to bark...')

        const shouldBark = isBarkTime()
        if (!shouldBark) {
            stopBarking()
            return
        }

        const randomIndex = Math.floor(Math.random() * VERBAL_ALERTS.length),
            dialog = VERBAL_ALERTS[randomIndex],
            preamble = "Meeting, '" + evt.summary + "'.",
            toSay = preamble + dialog

        console.log(`📢 Barking "${toSay}"`)
        await say(toSay)
    }, pauseFor)
}

function stopBarking() {
    if (!barking) return
    clearInterval(barking)

    barking = false

    console.log('🤫 Barking cancelled')
}

function getState() {
    return barking
}

module.exports = {
    start: startBarking,
    stop: stopBarking,
    getState,
}
