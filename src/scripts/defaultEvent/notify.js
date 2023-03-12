const bark = require('../../bark.js')
const handleAnswer = require('./answerHandler.js')
const { showMeetingAlert } = require('./displayAlert.js')
const {
    DIALOG_STAGES,
    ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES,
} = require('../../../config.js')

const giveUpAfter = ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES * 60

async function notifyUser(evt) {
    console.log(`🚨 Notifying user about '${evt.summary}' @ ${evt.startDate}`)

    const rightNow = new Date(),
        toGo = Math.floor((new Date(evt.startDate) - rightNow) / 1000),
        perStage = Math.floor(toGo / (DIALOG_STAGES.length - 1))

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
            console.log('Unhandled error:', e)
        }
        break
    }
}

module.exports = notifyUser
