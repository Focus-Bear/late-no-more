const exec = require('./exec.js')

async function checkForFocusBearInstall() {
    const SCRIPT = `
try
    set filePath to alias ((path to application support from user domain as text ) & "com.App.EarnYourScreenTime")
    return true
end try
return false
`
    return JSON.parse(await exec(SCRIPT))
}

async function readSettings() {
    const SCRIPT = `
set filePath to alias ((path to application support from user domain as text ) & "com.focusbear.latenomore:events.json")
set jsonString to (read file filePath) as text
log jsonString
return jsonString 
`
    return JSON.parse(await exec(SCRIPT))
}
module.exports = { readSettings, checkForFocusBearInstall }
