const { getEvents } = require('../calendar')
const { set, get } = require('./index.js')

module.exports = async function checkCalendars() {
    const { expired } = get(),
        events = await getEvents(),
        update = events.filter(
            (e) => !expired.map(({ id }) => id).includes(e?.id)
        )

    set('upcoming', update)
    console.log(`Found ${update.length} upcoming events`)
}
