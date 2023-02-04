const { showDialog } = require('../applescript/dialog.js')
const { update } = require('../csv.js')
const { calculateProximity } = require('../events/event.js')
const { nag } = require('./nag.js')

module.exports = async function (evt, now) {
    const { remove } = require('../events')
    const { intention, summary } = evt
    const { delta, imminent, soon } = calculateProximity(evt, now)

    if (!imminent) return

    const dialogTitle = 'Follow-Up: ' + summary,
        dialogText =
            `Your intention for this meeting was: ${
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
    await nag()
}
