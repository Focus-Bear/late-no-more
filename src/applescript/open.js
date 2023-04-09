const exec = require('./exec.js')

module.exports = function (command) {
    const escapedCommand = command.replace(/"/g, '\\"')
    const script = `do shell script "${escapedCommand}"`
    exec(script)
        .then((result) => {
            console.log('result', result)
        })
        .catch((e) => console.log(`Cannot "${command}"`))
    console.log(`Executed '${script}'`)
}
