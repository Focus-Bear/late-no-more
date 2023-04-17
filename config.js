const readSettings = require('./src/settings.js')

const IS_TESTING = process.env.NODE_ENV == 'test'

const ONE_DAY_IN_MILLI_SECONDS = 1000 * 60 * 60 * 24

const present = 'Attend meeting',
    truant = "I don't need to attend",
    MEETING_ACTION_BUTTONS = [truant, present]

const DIALOG_STAGES = [
        '😊 heads up, meeting starting soon!',
        '😅 fyi your meeting will begin in a moment',
        '😥 all aboard! meeting about to depart',
        '😰 final call!',
        '😱 you are late.',
    ],
    VERBAL_ALERTS = [
        'yellow alert, meeting imminent',
        'red alert',
        "heyyoo... it's time",
        'beep beep!',
        'meeting time!',
        'hey!! check your calendar!',
    ],
    MEETING_QUESTIONS = [
        'what do you want to contribute to the meeting?',
        'what will you learn?',
        'why is it important to pay attention in this meeting?',
    ]

const set = readSettings()

module.exports = {
    IS_TESTING,
    MEETING_ACTION_BUTTONS,
    ONE_DAY_IN_MILLI_SECONDS,
    DIALOG_STAGES: set?.dialogWindowTextStages || DIALOG_STAGES,
    MEETING_QUESTIONS: set?.intentionPrompts || MEETING_QUESTIONS,
    VERBAL_ALERTS: set?.barkPool || VERBAL_ALERTS,
    LOOK_AHEAD_MINUTES: set?.checkUpcomingLookAheadMinutes || 2,
    PAUSE_BETWEEN_BARKS_SECONDS: set?.pauseAfterBarkSeconds || 5,
    QUICK_NAP_DURATION_SECONDS: set?.checkUpcomingFrequencySeconds || 30,
    SLOW_NAP_DURATION_MINUTES: set?.checkCalendarFrequencyMinutes || 1,
    ALERT_WINDOW_GIVEUP_TIMEOUT_MINUTES: set?.dialogWindowTimeoutMinutes || 15,
}
