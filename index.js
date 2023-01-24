
const addTestEvents = require('./src/testing/index.js')
const { checkUpcoming, checkCalendars } = require('./src/core.js')
const { setCalsToExclude, setEventsToExclude } = require('./src/calendar')
const {
    readSettings,
    checkForFocusBearInstall,
} = require('./src/applescript/fs.js')
const { setNagState } = require('./src/intention.js')

const {
    SLOW_NAP_DURATION_MINUTES,
    QUICK_NAP_DURATION_SECONDS,
    ONE_DAY_IN_MILLI_SECONDS,
    IS_TESTING,
} = require('./config.js')

const quickInterval = QUICK_NAP_DURATION_SECONDS * 1000,
    slowInterval = SLOW_NAP_DURATION_MINUTES * 60_000,
    oneFullDay = ONE_DAY_IN_MILLI_SECONDS


async function setSettings() {
    const { excluded_calendars, excluded_events } = await readSettings()
    await setCalsToExclude(excluded_calendars)
    await setEventsToExclude(excluded_events)
    await setNagState()
}

async function main() {
    console.log('Late No More Online..')
    await setSettings()

    if (IS_TESTING) await addTestEvents()
    else await checkCalendars()
    checkUpcoming()

    setInterval(checkUpcoming, quickInterval)
    setInterval(checkCalendars, slowInterval)
    setInterval(setNagState, oneFullDay)
}

main()
    .then(() => {})
    .catch((e) => console.log(e))
