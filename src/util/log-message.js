const fs = require('fs');
const path = require('path');

function logToFile(...messages) {
    // specify the path to your log file
    const logFilePath = path.join(__dirname, 'late-no-more-log.txt');

    // create a timestamp
    const timestamp = new Date().toISOString();

    // convert all arguments to string and join them with a space
    const message = messages.map(arg => typeof arg === 'object' ? JSON.stringify(arg) : arg).join(' ');

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
