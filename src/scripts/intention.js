const csv = require('../csv.js')
const { askQuestion } = require('../applescript/dialog.js')
const {
    MEETING_QUESTIONS,
    QUICK_NAP_DURATION_SECONDS,
} = require('../../config.js')

async function takeNotes(evt) {
    const notesTitle = `${evt.summary}: Meeting Notes`,
        notesText =
            (evt?.intention
                ? `Your intention for this meeting is \n\n${evt.intention}\n\n`
                : '') + `Notes:`

    const save = 'Save notes',
        skip = 'No notes required',
        buttons = [skip, save]

    const { buttonReturned, userInput } = await askQuestion(
        notesText,
        notesTitle,
        buttons,
        save
    )

    if (buttonReturned === skip) return
    if (buttonReturned === save) {
        const row = { id: evt.id, notes: userInput.trim() }

        await csv.update(row)
    }
}

module.exports = async function setMeetingIntention(evt) {
    const events = require('../events')

    const question = MEETING_QUESTIONS.join('\n'),
        title = 'Set meeting intention',
        cancel = 'Cancel',
        intent = 'Set intention',
        buttons = [cancel, intent]

    const { userInput: intention } = await askQuestion(
        question,
        title,
        buttons,
        intent
    ) || ''

    const cannonical = intention.trim()

    if (!cannonical.length) {
        // I forget:
        // do we want to offer to save notes when
        // an intention setting is declined

        // takeNotes(evt)
        return
    }

    const { startDate, endDate, summary } = evt,
        row = {
            date: startDate,
            summary,
            id: evt.id,
            intention: cannonical,
        }

    await csv.update(row)

    const newEndDate = new Date(startDate)
    const napLength = QUICK_NAP_DURATION_SECONDS / 60
    newEndDate.setMinutes(endDate.getMinutes() + napLength + 1)

    const followUp = {
        ...evt,
        startDate: endDate,
        endDate: newEndDate,
        type: 'meetingEnd',
        intention,
    }

    events.add('upcoming', followUp)
    // we pass the later event becuase
    // it resolves which csv line to update based on uid
    // plus the intention itself is associated with this evt
    takeNotes(followUp)
}
