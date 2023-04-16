const fs = require('fs')
const os = require('os')
const path = require('path')

module.exports = function () {
    const appSupportPath = path.join(
        os.homedir(),
        'Library',
        'Application Support'
    )
    const filePath = path.join(
        appSupportPath,
        'com.focusbear.latenomore',
        'events.json'
    )

    const data = fs.readFileSync(filePath, 'utf8')
    return JSON.parse(data)
}
