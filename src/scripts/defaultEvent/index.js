const { warnUser } = require('./displayAlert.js')
const notifyUser = require('./notify.js')
const { calculateProximity } = require('../../events/event.js')

module.exports = function (evt, now) {
    const events = require('../../events'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    console.log('defaultEvent()')
    if (delta && imminent) {
        events.remove('looming', evt)
        events.add('active', evt)
        notifyUser(evt)
        return
    }
    if (soon && !events.has('looming', evt)) {
        events.add('looming', evt)
        warnUser(evt)
    }
}
