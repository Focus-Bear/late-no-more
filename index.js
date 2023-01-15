//require("./src/keyboard.js");

const addTestEvents = require('./src/testing/index.js')

const {
    syncCalendarsToUpcoming,
    checkUpcomingForMeetings,
} = require('./src/upcoming.js')

const {
    SLOW_NAP_DURATION_MINUTES,
    QUICK_NAP_DURATION_SECONDS,
    ONE_DAY_IN_MILLI_SECONDS,
    IS_TESTING,
} = require('./config.js')

const quickInterval = QUICK_NAP_DURATION_SECONDS * 1000,
    slowInterval = SLOW_NAP_DURATION_MINUTES * 60_000

async function main() {
    console.log('Late No More Online..')
    if (IS_TESTING) await addTestEvents()
    else syncCalendarsToUpcoming()
    checkUpcomingForMeetings()

    setInterval(checkUpcomingForMeetings, quickInterval)
    setInterval(syncCalendarsToUpcoming, slowInterval)
}

main()
    .then(() => {})
    .catch((e) => console.log(e))
