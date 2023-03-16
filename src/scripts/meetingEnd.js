const { showDialog } = require('../applescript/dialog.js')
const { update } = require('../csv.js')
const { calculateProximity } = require('../events/event.js')
const { nag } = require('./nag.js')

module.exports = async function (evt, now) {
    const events = require('../events/index.js')
    const { intention, summary } = evt
    const { imminent } = calculateProximity(evt, now)

    if (!imminent) return

    events.remove('upcoming', evt, 'Meeting feedback captured')

    const dialogTitle = 'Follow-Up: ' + summary,
        dialogText =
            `Your intention for this meeting was: ${
                '\n\n' + intention + '\n\n'
            }` + 'Do you feel you accomplished it?',
        INTENTION_BUTTONS = ['Yes', 'Sort of', 'No']

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
