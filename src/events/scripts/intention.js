const { update } = require('../../fs.js')
const { askQuestion } = require('../../applescript/dialog.js')
const { MEETING_QUESTIONS } = require('../../../config.js')

async function takeNotes(evt) {
    const notesTitle = `${evt.summary}: Meeting Notes`,
        notesText = `Your intention for this meeting is '${evt.intention}'.\n\nNotes:`,
        save = 'Save notes',
        skip = 'No notes required',
        disregard = 'Disregard intention',
        buttons = [skip, disregard, save]

    const { buttonReturned, userInput } = await askQuestion(
        notesText,
        notesTitle,
        buttons,
        save
    )

    if (buttonReturned === save) {
        const { startDate: date, summary } = evt,
            row = { id: evt.id, notes: userInput.trim() }

        await update(row)
    }
}

module.exports = async function setMeetingIntention(evt) {
    const events = require('../index.js')

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
    )
    if (!intention) return

    const { startDate: date, summary } = evt,
        row = { date, summary, id: evt.id, intention: intention.trim() }

    await update(row)

    const followUp = {
        ...evt,
        startDate: evt.endDate,
        type: 'meetingEnd',
        intention,
    }
    events.add('upcoming', followUp)
    await takeNotes(followUp)
}
