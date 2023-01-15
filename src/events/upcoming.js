const events = require('./index.js')
const scriptIndex = require('./scripts/')

module.exports = async function checkUpcoming() {
    console.log('checkUpcoming()')
    const { upcoming, expired } = events.get()
    console.log({ upcoming })
    if (!upcoming?.length) {
        return
    }

    const { length: count } = upcoming,
        now = new Date()

    const s = count > 1 ? 's' : ''
    console.log(`Waiting on ${count} upcoming event${s}`)

    for (let i = 0; i < upcoming.length; i++) {
        const evt = upcoming[i],
            handler = scriptIndex[evt.type]

        handler(evt, now)
    }

    if (expired.length) {
        console.log('Removing expired event(s) from upcoming list')
        const update = upcoming.filter((evt) => !expired.includes(evt.uid))
        set('upcoming', update)
    }
}
