const say = require('../applescript/say.js')
const exec = require('../applescript/exec.js')

const isBarkTime = require('./schedule.js')
const checkForServices = require('./services.js')

const {
    VERBAL_ALERTS,
    PAUSE_BETWEEN_BARKS_SECONDS,
} = require('../../config.js')

let barking = false

async function awaken() {
    const coffee = `do shell script "caffeinate -u -t 1"`
    console.log('☕️ Waking up display if sleeping...')
    await exec(coffee)
}

async function startBarking(evt) {
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
