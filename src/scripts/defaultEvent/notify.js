const bark = require('../../bark/index.js')
const handleAnswer = require('./answerHandler.js')
const { checkForFocusBearInstall } = require('../../applescript/fs.js')
const open = require('../../applescript/open.js')
const { logToFile } = require('../../util/log-message.js')

const { showMeetingAlert } = require('./displayAlert.js')
const {
    DIALOG_STAGES,
    ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES,
} = require('../../../config.js')

const giveUpAfter = ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES * 60

async function notifyUser(evt) {
    logToFile(`🚨 Notifying user about '${evt.summary}' @ ${evt.startDate}`)

    const rightNow = new Date(),
        toGo = Math.floor((new Date(evt.startDate) - rightNow) / 1000),
        perStage = Math.floor(toGo / (DIALOG_STAGES.length - 1))

    let fbInstalled = await checkForFocusBearInstall()

    if (fbInstalled) {
        const focusBearAboutToStartUrl = `open \"focusbear://event-about-to-start?event_title=${evt.summary}&event_description=${evt.description}&event_start_time=${evt.startDate}&event_end_time=${evt.endDate}\"`
        logToFile(`Triggering FB event-about-to-start: ${focusBearAboutToStartUrl}`)

        open(focusBearAboutToStartUrl)
    }

    for (let i = 0; i < DIALOG_STAGES.length; i++) {
        const line = DIALOG_STAGES[i],
            lastRow = i + 1 == DIALOG_STAGES.length,
            givingUpAfter = !lastRow ? perStage : giveUpAfter,
            barking = bark.getState()

        if (barking && !lastRow) bark.stop()
        if (lastRow) bark.start(evt)

        try {
            const answer = await showMeetingAlert(evt, line, givingUpAfter)
            await handleAnswer(evt, answer)
        } catch (e) {
            const { type } = e
            if (type == 'continue') continue
            if (type == 'break') break
            logToFile('Unhandled error:', e)
        }
        bark.stop() // this might not be necessary
        break
    }
}

module.exports = notifyUser
