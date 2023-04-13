const exec = require('./exec.js')
const { readSettings } = require('./fs.js')

const { voiceOptions: options } = readSettings()

module.exports = async function say(dialog) {
    const optionStrings = {
        using: (value) => ` using "${value}"`,
        speakingRate: (value) => ` speaking rate ${value}`,
        pitch: (value) => ` pitch ${value}`,
        modulation: (value) => ` modulation ${value}`,
        volume: (value) => ` volume ${value}`,
        stopCurrentSpeech: (value) => (value ? ` stopping current speech` : ''),
        waitForCompletion: (value) =>
            value ? ` waiting until completion true` : '',
        saveTo: (value) => ` saving to "${value}"`,
    }

    let SCRIPT = `say "${dialog}"`

    for (const key in options) {
        const option = options?.[key]
        if (option === undefined) continue

        if (optionStrings.hasOwnProperty(key)) {
            const optionValue = options[key]
            SCRIPT += optionStrings[key](optionValue)
        }
    }

    await exec(SCRIPT)
}
