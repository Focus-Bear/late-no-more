const open = require('../../applescript/open.js')
const { logToFile } = require('../../util/log-message.js')

function extractLine(str) {
    const lines = str.split('\n')
    if (!lines?.length) return str

    const [hit] = lines.filter((x) => x.includes('fbtrigger:'))

    const [final] = hit.trim().split(':').reverse()
    return final
}

function getEventDuration(event) {
    const startDate = new Date(event.startDate)
    const endDate = new Date(event.endDate)
    const duration = (endDate.getTime() - startDate.getTime()) / 1000 / 60
    return duration
}

function checkForTrigger(evt) {
    const { summary, description } = evt

    const toLookAt = [summary, description]

    for (const str of toLookAt) {
        if (!str?.includes('fbtrigger:')) {
            continue
        }
        const trigger = extractLine(str)
        return trigger
    }
    return false
}

module.exports = function handleTrigger(evt) {
    const trigger = checkForTrigger(evt)
    if (!trigger) return

    logToFile(`📍 Found trigger "${trigger}", opening...`)
    const duration = getEventDuration(evt)
    const url = `open \"focusbear://start-activity?activity_id=${trigger}&duration_seconds=${duration}\"`

    open(url)
}
