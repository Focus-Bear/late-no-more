const { showDialog } = require('../../applescript/dialog.js')
const { update } = require('../../fs.js')

module.exports = async function (evt) {
    const { remove } = require('../../events/index')
    const { intention, summary } = evt

    const dialogTitle = 'Follow-Up: ' + summary,
        dialogText =
            `Your intention for this meeting was: ${
                '\n\n' + intention.trim() + '\n\n'
            }` + 'Do you feel you accomplished it?',
        INTENTION_BUTTONS = ['Yes', 'Sort of', 'No']

    const success = await showDialog(dialogTitle, dialogText, INTENTION_BUTTONS)

    const row = { id: evt.id, success }
    await update(row)
    remove('upcoming', evt)
}
