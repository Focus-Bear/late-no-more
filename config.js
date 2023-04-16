const readSettings = require('./src/settings.js')

const IS_TESTING = process.env.NODE_ENV == 'test'

const ONE_DAY_IN_MILLI_SECONDS = 1000 * 60 * 60 * 24

const present = 'Attend meeting',
    truant = "I don't need to attend",
    MEETING_ACTION_BUTTONS = [truant, present]

const set = readSettings()

module.exports = {
    IS_TESTING,
    MEETING_ACTION_BUTTONS,
    ONE_DAY_IN_MILLI_SECONDS,
    DIALOG_STAGES: set.dialogWindowTextStages,
    LOOK_AHEAD_MINUTES: set.checkUpcomingLookAheadMinutes,
    PAUSE_BETWEEN_BARKS_SECONDS: set.pauseAfterBarkSeconds,
    MEETING_QUESTIONS: set.intentionPrompts,
    VERBAL_ALERTS: set.barkPool,
    QUICK_NAP_DURATION_SECONDS: set.checkUpcomingFrequencySeconds,
    SLOW_NAP_DURATION_MINUTES: set.checkCalendarFrequencyMinutes,
    ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES: set.dialogWindowTimeoutMinutes,
}
