const events = require('./events')

module.exports = function prune() {
    const { active, upcoming, looming } = events.get()

    const expiry = new Date(Date.now())

    const all = { active, looming, upcoming }

    for (const listName in all) {
        const current = all[listName]
        for (const evt of current) {
            console.log({ listName, evt, expiry })
            if (expiry < evt.endDate) continue
            console.log('Pruning old event', listName, evt)
            events.remove(listName, evt)
        }
    }
}
