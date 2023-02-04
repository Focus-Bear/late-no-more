const { showDialog } = require('../applescript/dialog.js')
const { update } = require('../csv.js')
<<<<<<< HEAD
const { calculateProximity } = require('../events/event.js')
const { nag } = require('./nag.js')

module.exports = async function (evt, now) {
    const { remove } = require('../events')
    const { intention, summary } = evt
    const { delta, imminent, soon } = calculateProximity(evt, now)

    if (!imminent) return
=======
const { nag } = require('./nag.js')

module.exports = async function (evt) {
    const { remove } = require('../events')
    const { intention, summary } = evt
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567

    const dialogTitle = 'Follow-Up: ' + summary,
        dialogText =
            `Your intention for this meeting was: ${
<<<<<<< HEAD
                '\n\n' + intention + '\n\n'
            }` + 'Do you feel you accomplished it?',
        INTENTION_BUTTONS = ['Yes', 'Sort of', 'No']

    remove('upcoming', evt)
    const success = await showDialog(
        dialogTitle,
        dialogText,
        INTENTION_BUTTONS,
        0
    )

    const row = { id: evt.id, success }
    await update(row)
=======
                '\n\n' + intention.trim() + '\n\n'
            }` + 'Do you feel you accomplished it?',
        INTENTION_BUTTONS = ['Yes', 'Sort of', 'No']

    const success = await showDialog(dialogTitle, dialogText, INTENTION_BUTTONS)

    const row = { id: evt.id, success }
    await update(row)
    remove('upcoming', evt)
>>>>>>> 04b0491017f977c10bbcba1ffe5008dd66464567
    await nag()
}
