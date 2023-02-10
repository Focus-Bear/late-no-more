const csv = require('../csv.js')
const { askQuestion } = require('../applescript/dialog.js')
const { MEETING_QUESTIONS } = require('../../config.js')

async function takeNotes(evt) {
    const events = require('../events')

    const notesTitle = `${evt.summary}: Meeting Notes`,
        notesText = `Your intention for this meeting is \n\n${evt.intention}\n\nNotes:`,
        save = 'Save notes',
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
        const { startDate: date, summary } = evt,
            row = { id: evt.id, notes: userInput.trim() }

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
    )

    const cannonical = intention.trim()

    if (!cannonical.length) return

    const { startDate, endDate, summary } = evt,
        row = {
            date: startDate,
            summary,
            id: evt.id,
            intention: cannonical,
        }

    await csv.update(row)

    const followUp = {
        ...evt,
        startDate: endDate,
        type: 'meetingEnd',
        intention,
    }

    events.add('upcoming', followUp)
    await takeNotes(followUp)
}
