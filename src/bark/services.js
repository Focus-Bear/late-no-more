const exec = require('../applescript/exec.js')
const openURL = require('../applescript/event.js')
const { logToFile } = require('../util/log-message.js')

async function getTrackDuration(trackUri) {
    const command = `
      tell application "Spotify"
        activate
        open location "${trackUri}"
        set trackDuration to duration of current track
        return trackDuration
      end tell
    `
    const duration = await exec(command)
    return duration
}

let timeoutId

async function openSpotifyTrack(trackUri) {
    if (timeoutId) {
        clearTimeout(timeoutId)
    }

    const duration = await getTrackDuration(trackUri)

    const play = `
    tell application "Spotify"
      play track "${trackUri}"
    end tell
  `
    await exec(play)
    logToFile('🔊 Playing Track ' + trackUri)

    const pause = `
    tell application "Spotify"
      pause
    end tell
  `
    timeoutId = setTimeout(async () => {
        logToFile('⏸️ Pausing track!')
        await exec(pause)
    }, duration)
}

module.exports = async function checkForServices(line) {
    if (line.includes('spotify')) {
        let spotifyUri = line
        if (line.includes("open.spotify.com/track/")) {
            const trackId = line.split("/track/")[1].split("?")[0];
            spotifyUri = `spotify:track:${trackId}`;
        }
        if (spotifyUri.startsWith('spotify:')) {
            await openSpotifyTrack(spotifyUri)
            return true
        }
    }
    if (line.includes('youtube.com')) {
        openURL(line)
        return true
    }
}
