const applescript = require('applescript');

module.exports = function exec(SCRIPT) {
    return new Promise((resolve, reject) => {
        return applescript.execString(SCRIPT, (err, rtn) => {
            if (err) {
                reject(err)
            }
            resolve(rtn)
        })
    })
}
