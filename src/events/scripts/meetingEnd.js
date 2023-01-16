const { showDialog } = require('../../applescript/dialog.js')

module.exports = async function (evt) {
    const { intention, summary } = evt

    const dialogTitle = 'Follow-Up: ' + summary,
        dialogText =
            `Your intention for this meeting was: ${'\n\n' + intention + '\n\n'}` +
            'Do you feel you accomplished it?',
        INTENTION_BUTTONS = ['Yes', 'Sort of', 'No']

    const response = await showDialog(dialogTitle, dialogText, INTENTION_BUTTONS)
    console.log({response})
    // save response
}
