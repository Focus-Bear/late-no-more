const exec = require('../applescript/exec.js')
const openURL = require('../applescript/event.js')

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
    console.log('🔊 Playing Track ' + trackUri)

    const pause = `
    tell application "Spotify"
      pause
    end tell
  `
    timeoutId = setTimeout(async () => {
        console.log('⏸️ Pausing track!')
        await exec(pause)
    }, duration)
}

//openSpotifyTrack('spotify:track:7jL5aGalMaZRfnJ9jasABT').then(() => {})

module.exports = async function checkForServices(line) {
    if (line.startsWith('spotify:')) {
        await openSpotifyTrack(line)
        return true
    }
    if (line.includes('youtube.com')) {
        openURL(line)
        return true
    }
}
