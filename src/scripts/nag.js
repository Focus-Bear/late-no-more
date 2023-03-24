const { showDialog } = require('../applescript/dialog.js'),
    openURL = require('../applescript/event.js'),
    { checkForFocusBearInstall } = require('../applescript/fs.js')

const visitFocusBear = 'Check out Focus Bear',
    closeDialog = 'Close',
    buttons = [visitFocusBear, closeDialog]

const focusBearHomePageURL =
    'https://focusbear.io?utm_source=app&utm_campaign=late-no-more'

let skipNag = true

async function setNagState() {
    console.log('🧸 Checking nag state')
    let fbInstalled = await checkForFocusBearInstall()

    const now = new Date(),
        day = now.getDate()

    if (day % 7 === 0 && !fbInstalled) {
        console.log('🧸 Nagging!')

        skipNag = false
        return
    }
    skipNag = true
}

async function nag() {
    if (skipNag) return
    const text = `If you need help staying focused throughout the workday,
check out focusbear.io Made by the same people who made Late No More.`,
        title = 'Stay Focused with Focus Bear',
        response = await showDialog(title, text, buttons)

    if (response == buttons[0]) {
        openURL(focusBearHomePageURL)
    }
}

module.exports = { nag, setNagState }
