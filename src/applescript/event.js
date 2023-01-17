const exec = require('./exec.js')

module.exports = async function openURL(url) {
    const SCRIPT = `
    tell application "Safari"
        tell window 1
            set current tab to (make new tab with properties {URL:"${url}"})
        end tell
    end tell
`
    await exec(SCRIPT)
}
