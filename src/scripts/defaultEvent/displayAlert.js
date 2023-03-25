const { showDialog, askQuestion } = require('../../applescript/dialog.js')
const {
    LOOK_AHEAD_MINUTES,
    MEETING_ACTION_BUTTONS,
} = require('../../../config.js')

async function warnUser(evt) {
    const title = `Late No More: ${evt.summary} (${evt.calendarName}) is starting in 15 minutes.`,
        text = `I'll remind you again ${LOOK_AHEAD_MINUTES} minutes before.`,
        buttons = ['Got it']

    await showDialog(title, text, buttons, 15)
}

async function showMeetingAlert(evt, line, givingUpAfter, showImage = false) {
    console.log('🔔 Displaying alert')
    const title = `Late No More: ${evt.summary}`,
        br = '\n',
        text = [evt.startDate, br, line, br, evt.location, evt.url].join(br),
        buttons = MEETING_ACTION_BUTTONS

    return await showDialog(title, text, buttons, givingUpAfter, showImage)
}

module.exports = { showMeetingAlert, warnUser }
