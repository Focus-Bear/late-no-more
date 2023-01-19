const say = require('@applescript/say.js')

const {
    DIALOG_STAGES,
    VERBAL_ALERTS,
    MEETING_QUESTIONS,
    MEETING_ACTION_BUTTONS,
    PAUSE_BETWEEN_BARKS_SECONDS,
    LOOK_AHEAD_MINUTES,
} = require('@root/config.js')

let barking = false

function startBarking(evt) {
    console.log('Starting barks...')
    const pauseFor = PAUSE_BETWEEN_BARKS_SECONDS * 1000

    barking = setInterval(async () => {
        console.log('In barking interval...')
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

function getState(){
    return barking
}

module.exports = {
    start: startBarking,
    stop: stopBarking,
    getState

}
