const exec = require('./exec.js')

module.exports = async function say(dialog, options = {}) {
    const defaultOptions = {
        using: 'Karen',
        speakingRate: 150,
        pitch: 50,
        volume: 0.5,
        modulation: 2,
        waitForCompletion: true,
    }

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

    const combinedOptions = { ...defaultOptions, ...options }

    let SCRIPT = `say "${dialog}"`

    for (const key in combinedOptions) {
        const option = combinedOptions?.[key]
        if (option === undefined) continue

        if (optionStrings.hasOwnProperty(key)) {
            const optionValue = combinedOptions[key]
            SCRIPT += optionStrings[key](optionValue)
        }
    }

    await exec(SCRIPT)
}
