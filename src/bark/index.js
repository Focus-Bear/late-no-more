const say = require('../applescript/say.js')
const exec = require('../applescript/exec.js')

const isBarkTime = require('./schedule.js')
const checkForServices = require('./services.js')
const { logToFile } = require('../util/log-message.js')

const {
    VERBAL_ALERTS,
    PAUSE_BETWEEN_BARKS_SECONDS,
} = require('../../config.js')

let barking = false

async function awaken() {
    const coffee = `do shell script "caffeinate -u -t 1"`
    logToFile('☕️ Waking up display if sleeping...')
    const result = await exec(coffee)
    logToFile(result)
}

async function startBarking(evt) {
    logToFile('🐕 Barking requested!')
    const pauseFor = PAUSE_BETWEEN_BARKS_SECONDS * 1000

    if (barking) {
        // prevents bark overlap
        clearInterval(barking)
    }

    barking = setInterval(async () => {
        logToFile('🐶 Preparing to bark...')

        const shouldBark = isBarkTime()
        if (!shouldBark) {
            stopBarking()
            return
        }
        await awaken()

        const randomIndex = Math.floor(Math.random() * VERBAL_ALERTS.length),
            dialog = VERBAL_ALERTS[randomIndex],
            preamble = "Meeting, '" + evt.summary + "': ",
            toSay = preamble + dialog

        const handled = await checkForServices(dialog)

        if (handled) {
            stopBarking()
            return
        }

        logToFile(`📢 Barking "${toSay}"`)
        await say(toSay)
    }, pauseFor)
}

function stopBarking() {
    if (!barking) return
    clearInterval(barking)

    barking = false

    logToFile('🤫 Barking cancelled')
}

function getState() {
    return barking
}

module.exports = {
    start: startBarking,
    stop: stopBarking,
    getState,
}
