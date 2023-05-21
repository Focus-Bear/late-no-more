const { readSettings } = require('../applescript/fs.js')
const { logToFile } = require('../util/log-message.js')

let barkTime

async function setBarkTime() {
    const { barkStartTime, barkEndTime } = await readSettings()
    barkTime = { startTime: barkStartTime, endTime: barkEndTime }
    logToFile(`📙 Allowed to bark ${barkStartTime}-${barkEndTime}`)
}
setBarkTime()

function isBarkTime() {
    const [startHr, startMin] = barkTime.startTime.split(':')
    const [endHr, endMin] = barkTime.endTime.split(':')

    const startAt = new Date()
    startAt.setHours(startHr)
    startAt.setMinutes(startMin)

    const endAt = new Date()
    endAt.setHours(endHr)
    endAt.setMinutes(endMin)

    const rn = new Date(Date.now())

    return rn >= startAt && rn <= endAt
}

module.exports = isBarkTime
