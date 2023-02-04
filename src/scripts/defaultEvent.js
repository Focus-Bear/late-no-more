const { calculateProximity } = require('../events/event.js')
const bark = require('../bark.js'),
    {
        DIALOG_STAGES,
        LOOK_AHEAD_MINUTES,
        MEETING_ACTION_BUTTONS,
        MEETING_QUESTIONS,
<<<<<<< HEAD
        ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES,
=======
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    } = require('../../config.js')

const { showDialog, askQuestion } = require('../applescript/dialog.js')
const openMeetingURL = require('../applescript/event.js')
const setMeetingIntention = require('./intention.js')

<<<<<<< HEAD
const giveUpAfter = ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES * 60_000

async function showMeetingAlert(evt, line, givingUpAfter, showImage = false) {
    console.log('showMeetingAlert()')
    const title = `Late No More: ${evt.summary}`,
        br = '\n',
        text = [evt.startDate, br, line, br, evt.location, evt.url].join(br),
=======
async function showMeetingAlert(evt, line, givingUpAfter, showImage = false) {
    console.log('showMeetingAlert()')
    const title = `Late No More: ${evt.summary} ${evt.startDate}`,
        text = [line, '\n', evt.location, evt.url].join('\n'),
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
        buttons = MEETING_ACTION_BUTTONS

    return await showDialog(title, text, buttons, givingUpAfter, showImage)
}

async function warnUser(evt) {
    const title = `Late No More: ${evt.summary} (${evt.calendarName}) is starting in 15 minutes.`,
        text = `I'll remind you again ${LOOK_AHEAD_MINUTES} minutes before.`,
        buttons = ['Got it', 'Close']

    await showDialog(title, text, buttons, 15)
}

async function attendMeeting(evt) {
    console.log('Opening meeting url, if present')
    if (evt?.url) {
        await openMeetingURL(evt.url)
        return
    }

    if (evt?.location?.startsWith('http')) {
        await openMeetingURL(evt.location)
    }
}

async function handleAnswer(evt, answer) {
<<<<<<< HEAD
    const [ truant, present] = MEETING_ACTION_BUTTONS
=======
    const [intent, present, truant] = MEETING_ACTION_BUTTONS
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    if (!answer?.length) {
        console.log('no answer, continuing')
        throw { type: 'continue' }
    }

    bark.stop()

<<<<<<< HEAD
=======
    console.log({ answer })
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    if (answer == truant) {
        throw { type: 'break' }
    }

<<<<<<< HEAD
    if (answer == present) {
        await attendMeeting(evt)
        await setMeetingIntention(evt)
        throw { type: 'break' }
    }
=======
    await attendMeeting(evt)
    await setMeetingIntention(evt)
    throw { type: 'break' }
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
}

async function notifyUser(evt) {
    console.log('Notifying user about', evt.summary, evt.startDate)

    const rightNow = new Date(),
        toGo = Math.floor((new Date(evt.startDate) - rightNow) / 1000),
        perStage = Math.floor(toGo / (DIALOG_STAGES.length - 1))

    for (let i = 0; i < DIALOG_STAGES.length; i++) {
        const line = DIALOG_STAGES[i],
            lastRow = i + 1 == DIALOG_STAGES.length,
<<<<<<< HEAD
            givingUpAfter = !lastRow ? perStage : giveUpAfter,
=======
            givingUpAfter = !lastRow ? perStage : 0,
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
            barking = bark.getState()

        //   if (lastRow && barking) bark.stop() // catch edge case where barking misbehaves
        if (lastRow) bark.start(evt)

        try {
            const answer = await showMeetingAlert(evt, line, givingUpAfter)
            await handleAnswer(evt, answer)
        } catch ({ type }) {
            if (type == 'continue') continue
            if (type == 'break') break
        }

        break
    }
}

module.exports = function (evt, now) {
    const events = require('../events'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    const { looming } = events.get()

    if (soon && !events.has('looming', evt)) {
        events.add('looming', evt)
        warnUser(evt)
    }

    if (delta && imminent) {
        events.remove('upcoming', evt)
        events.remove('looming', evt)
<<<<<<< HEAD
        notifyUser(evt)
    }
=======
        events.add('expired', evt)
        notifyUser(evt)
    }
    // Super late now - stop hassling them
    if (delta <= -10) {
        events.add('expired', evt)
    }
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
}
