const fs = require('fs');
const path = require('path');
const os = require('os');

function logToFile(...messages) {
    // specify the path to your log file
    const logDirectory = path.join(os.homedir(), 'late-no-more-logs');
    // ensure log directory exists
    if (!fs.existsSync(logDirectory)) {
        fs.mkdirSync(logDirectory);
    }

    const logFilePath = path.join(logDirectory, 'late-no-more-log.txt');

    // create a timestamp
    const timestamp = new Date().toISOString();

    // convert all arguments to string and join them with a space
    const message = messages.map(arg => {
        if (arg instanceof Error) {
            return arg.stack;
        } else if (typeof arg === 'object') {
            return JSON.stringify(arg);
        } else {
            return arg;
        }
    }).join(' ');

    // create the log message with the timestamp
    const logMessage = `${timestamp}: ${message}\n`;

    console.log(logMessage)

    // append the log message to the log file
    fs.appendFile(logFilePath, logMessage, (err) => {
        if (err) throw err;
    });
}

module.exports = {
    logToFile
}
