const { warnUser } = require('./displayAlert.js')
const notifyUser = require('./notify.js')
const { calculateProximity } = require('../../events/event.js')

module.exports = function (evt, now) {
    const events = require('../../events'),
        { delta, imminent, soon } = calculateProximity(evt, now)

    if (events.has('active', evt)) {
        // if the event has already been imminent,
        // we won't handle it again
        return
    }

    if (delta && imminent) {
        // if we're within the 2 minute window,
        // move the event to active and let the user know
        events.add('active', evt)
        notifyUser(evt)
        return
    }

    if (!soon || events.has('looming', evt)) {
        // we've already notified the user
        // so we're going to do nothing
        return
    }

    // if this is our first time seeing the event
    // add it to looming so it can be ignored
    events.add('looming', evt)
    warnUser(evt)
}
