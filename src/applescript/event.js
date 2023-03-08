const exec = require('./exec.js')

module.exports = async function openURL(url) {
    const SCRIPT = `
    open location \"${url}\"
`
    await exec(SCRIPT)
}
