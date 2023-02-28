const { warnUser } = require('./displayAlert.js')
const notifyUser = require('./notify.js')
const { calculateProximity } = require('../../events/event.js')

module.exports = function (evt, now) {
    const events = require('../../events'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    const { looming } = events.get()

    if (soon && !events.has('looming', evt)) {
        events.add('looming', evt)
        warnUser(evt)
    }

    if (delta && imminent) {
        notifyUser(evt)
    }
}
