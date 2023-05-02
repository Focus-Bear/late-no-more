const settings = require('../settings.js');
const exec = require('./exec.js')

let focusBearInstallStatusFromCache = {};

async function checkForFocusBearInstall() {
    if (Object.keys(focusBearInstallStatusFromCache).length > 0) {
        return focusBearInstallStatusFromCache.isInstalled;
    }
    try {
        const SCRIPT = `
        try
            set filePath to alias ((path to application support from user domain as text ) & "com.App.EarnYourScreenTime")
            return true
        end try
        return false
    `
        const isInstalled = JSON.parse(await exec(SCRIPT));
        focusBearInstallStatusFromCache.isInstalled = isInstalled;

        return isInstalled;
    } catch (e) {
        console.error('checkForFocusBear', e);
        return false;
    }
}

let settingsFromCache;

async function readSettings() {
    if (settingsFromCache) {
        return settingsFromCache
    }
    try {
        const SCRIPT = `
        set filePath to alias ((path to application support from user domain as text ) & "com.focusbear.latenomore:events.json")
        set jsonString to (read file filePath) as text
        return jsonString
        `
        const settingsFromFile = JSON.parse(await exec(SCRIPT));
        settingsFromCache = settingsFromFile;

        return settingsFromFile;
    } catch (e) {
        console.error('readSettings', e);
        return {};
    }
}

module.exports = { readSettings, checkForFocusBearInstall }
