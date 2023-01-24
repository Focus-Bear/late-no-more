const { LOOK_AHEAD_MINUTES } = require('../../config.js')

function calculateProximity(evt, now) {
    const delta = (new Date(evt.startDate) - now) / 1000,
        imminent = delta < LOOK_AHEAD_MINUTES * 60,
        soon = delta < 15.55 * 60 && delta > 14.45 * 60
    return { delta, soon, imminent }
}
module.exports = { calculateProximity }
