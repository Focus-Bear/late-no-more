const exec = require('../applescript/exec.js')
const openURL = require('../applescript/event.js')

async function openSpotifyTrack(trackUri) {
    const command = `
      tell application "Spotify"
        activate
        open location "${trackUri}"
      end tell
    `
    exec(command)
}

module.exports = function checkForServices(line) {
    if (line.startsWith('spotify:')) {
        openSpotifyTrack(line)
        return true
    }
    if (line.includes('youtube.com')) {
        openURL(line)
        return true
    }
}
