const { warnUser } = require('./displayAlert.js')
const notifyUser = require('./notify.js')
const { calculateProximity } = require('../../events/event.js')

module.exports = function (evt, now) {
    const events = require('../../events'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    if (delta && imminent) {
        events.remove('looming', evt)
        events.add('active', evt)
        notifyUser(evt)
        return
    }

    if (!soon && events.has('looming', evt)) return

    events.add('looming', evt)
    warnUser(evt)
}
