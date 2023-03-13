const addTestEvents = require('./src/testing/index.js')
const updateState = require('./src/index.js')
const { setCalsToExclude, setEventsToExclude } = require('./src/calendar')
const { readSettings } = require('./src/applescript/fs.js')
const { setNagState } = require('./src/scripts/nag.js')

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
    const { calendarsToExclude, eventKeywordsToIgnore } = await readSettings()
    await setCalsToExclude(calendarsToExclude)
    await setEventsToExclude(eventKeywordsToIgnore)
    await setNagState()
}

async function main() {
    console.log('Late No More Online..')
    await setSettings()

    if (IS_TESTING) await addTestEvents()

    await updateState()

    setInterval(updateState, quickInterval)
    setInterval(setNagState, oneFullDay)
}

main()
    .then(() => {})
    .catch((e) => console.log(e))
