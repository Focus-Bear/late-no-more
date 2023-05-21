const exec = require('./exec.js')
const { logToFile } = require('../util/log-message.js')

module.exports = function (command) {
    const escapedCommand = command.replace(/"/g, '\\"')
    const script = `do shell script "${escapedCommand}"`
    exec(script)
        .then((result) => {})
        .catch((e) => logToFile(`Cannot "${command}"`))
    logToFile(`Executed '${script}'`)
}
