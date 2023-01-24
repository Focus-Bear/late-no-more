const { showDialog } = require('./applescript/dialog.js'),
    openURL = require('./applescript/event.js'),
    { checkForFocusBearInstall } = require('./applescript/fs.js')

const visitFocusBear = 'Check out Focus Bear',
    closeDialog = 'Close',
    buttons = [visitFocusBear, closeDialog]

const focusBearHomePageURL =
    'https://focusbear.io?utm_source=app&utm_campaign=late-no-more'

let skipNag = true

async function setNagState() {
    let fbInstalled = await checkForFocusBearInstall()

    const now = new Date(),
        day = now.getDate()

    if (day % 7 === 0 && !fbInstalled) {
        skipNag = false
        return
    }
    skipNag = true
}

async function showIntention(intention) {
    if (skipNag) return
    const text = `Got it. Here's your intention for future reference: 

${intention}.

If you need help staying focused during meetings, check out focusbear.io 
Made by the same people who made this app.`,
        title = 'Your intention',
        response = await showDialog(title, text, buttons)

    if (response == buttons[0]) {
        openURL(focusBearHomePageURL)
    }
}

async function noIntention() {
    if (skipNag) return
    const text = `Got it. Enjoy a productive work session instead.

If you need help staying focused throughout the workday,
check out focusbear.io Made by the same people who made Late No More.`,
        title = 'Enjoy your work session!',
        response = await showDialog(title, text, buttons)

    if (response == buttons[0]) {
        openURL(focusBearHomePageURL)
    }
}

module.exports = { showIntention, noIntention, setNagState }
