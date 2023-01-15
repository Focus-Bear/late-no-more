const { calculateProximity } = require('../../events/event.js')
const bark = require('../../bark.js'),
    {
        DIALOG_STAGES,
        MEETING_ACTION_BUTTON,
        LOOK_AHEAD_MINUTES,
        MEETING_ACTION_BUTTONS,
    } = require('../../../config.js')

const {
    showDialog,
    askQuestion,
    openMeetingURL,
} = require('../../applescript/dialog.js')

const { showIntention, noIntention } = require('../../intention.js')

async function showMeetingAlert(evt, line, givingUpAfter, showImage = false) {
    const title = `Late No More: ${evt.summary} ${evt.startDate}`,
        text = [line, '\n', evt.location, evt.url].join('\n'),
        buttons = MEETING_ACTION_BUTTONS

    return await showDialog(title, text, buttons, givingUpAfter, showImage)
}

async function warnUser(evt) {
    const title = `Late No More: ${evt.summary} (${evt.calendarName}) is starting in 15 minutes.`,
        text = `I'll remind you again ${LOOK_AHEAD_MINUTES} minutes before.`,
        buttons = ['Got it', 'Close']

    await showDialog(title, text, buttons, 15)
}

async function handleAnswer(evt, answer) {
    if (!answer?.length) {
        console.log('no answer, continuing')
        throw { type: 'continue' }
    }
    const [present] = MEETING_ACTION_BUTTONS
    if (answer !== present) return

    if (evt?.url) {
        await openMeetingURL(evt.url)
    } else if (evt?.location?.startsWith('http')) {
        await openMeetingURL(evt.location)
    }

    const question = MEETING_QUESTIONS.join('\n'),
        intention = await askQuestion(question)

    await showIntention(intention)
    throw { type: 'break' }
}

async function notifyUser(evt) {
    console.log('Notifying user about', evt.summary, evt.startDate)

    const rightNow = new Date(),
        toGo = Math.floor((new Date(evt.startDate) - rightNow) / 1000),
        perStage = Math.floor(toGo / (DIALOG_STAGES.length - 1))

    for (let i = 0; i < DIALOG_STAGES.length; i++) {
        const line = DIALOG_STAGES[i],
            lastRow = i + 1 == DIALOG_STAGES.length,
            givingUpAfter = !lastRow ? perStage : 0

        if (lastRow && barking) bark.stop() // catch edge case where barking misbehaves
        if (lastRow) bark.start(evt)

        try {
            const answer = await showMeetingAlert(evt, line, givingUpAfter)
            await handleAnswer(evt, answer)
        } catch ({ type }) {
            if (type == 'continue') continue
            if (type == 'break') break
        }
        bark.stop()

        await noIntention()
        break
    }
}

module.exports = function (evt, now) {
    const events = require('../../events/index.js'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    if (soon && !looming.includes(evt?.id)) {
        events.add('looming', evt)
        warnUser(evt)
    }

    if (delta && imminent) {
        events.remove('upcoming', evt)
        events.remove('looming', evt)
        events.add('expired', evt)
        notifyUser(evt)
    }
    // Super late now - stop hassling them
    if (delta <= -10) {
        console.log('Delta', delta, evt)
        events.add('expired', evt)
    }
}
