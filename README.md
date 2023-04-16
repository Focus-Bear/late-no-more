# Late No More

Checks local iCal via AppleScript & notifies about upcoming events and meetings. This repo is for a piece of subfunctionality for the Late No More desktop app. To learn more, visit the Focus Bear website.

## Setup

Clone this repo and run:

`npm install`

Then

`npm run start`

or for testing

`npm run test`

## How it works

There are two core cycles in play:

1. First is to check iCal and save all meetings occurring in the next specified minutes to a local, in-memory list. This is governed by checkCalendarFrequencyMinutes.
2. Second is to check the upcomingEvents, in-memory list for any imminent meetings and notify. This is governed by checkUpcomingFrequencySeconds.
3. Upon meetings, optionally set an intention & write notes, which are saved to ~/Documents/LateNoMore-Meetings.csv.
   Configuration Options

Please see the Configuration Options section below for details on each setting.

## Example Configuration

```
{
  "checkUpcomingLookAheadMinutes": 2,
  "checkCalendarFrequencyMinutes": 1,
  "checkUpcomingFrequencySeconds": 30,
  "pauseAfterBarkSeconds": 5,
  "dialogWindowTimeoutMinutes": 15,
  "barkStartTime": "07:00",
  "barkEndTime": "21:00",
  "calendarsToExclude": [
    {
      "name": "Holidays in Australia",
      "id": "24516AA2-7D42-49FE-803F-76F3DE727A53"
    }
  ],
  "eventKeywordsToIgnore": ["no-notify", "focus", "blocked"],
  "voiceOptions": {
    "using": "Karen",            // Supported voice names by AppleScript
    "speakingRate": 150,         // Integer value between 50 and 300 words per minute
    "pitch": 50,                 // Integer value between 0 and 100 (0 = lowest pitch, 100 = highest pitch)
    "volume": 0.5,               // Float value between 0.0 and 1.0 (0.0 = silent, 1.0 = maximum volume)
    "modulation": 2,             // Integer value between 0 and 10 (0 = no modulation, 10 = highest modulation)
    "waitForCompletion": true    // Boolean value (true or false)
  },
  "barkPool": [
    "spotify:track:7jL5aGalMaZRfnJ9jasABT",
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "Time for a meeting!"
  ],
  "dialogWindowTextStages": [
    "😊 heads up, meeting starting soon!",
    "😅 fyi your meeting will begin in a moment",
    "😥 all aboard! meeting about to depart",
    "😰 final call!",
    "😱 you are late."
  ],
  "intentionPrompts": [
    "what do you want to contribute to the meeting?",
    "what will you learn?",
    "why is it important to pay attention in this meeting?"
  ]
}
```

## Configuration Options

The settings.json file contains various configuration options for Late No More. Refer to the Example Configuration section above for a full example.
| Setting                        | Type                          | Description                                                                                                                |
| ------------------------------ | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| checkUpcomingLookAheadMinutes  | Integer                       | The number of minutes to look ahead in the calendar for upcoming meetings.                                                 |
| checkCalendarFrequencyMinutes  | Integer                       | The frequency in minutes at which the application checks the calendar for new events.                                      |
| checkUpcomingFrequencySeconds  | Integer                       | The frequency in seconds at which the application checks for upcoming meetings to alert the user.                          |
| pauseAfterBarkSeconds          | Integer                       | The duration in seconds to pause between verbal alerts.                                                                   |
| dialogWindowTimeoutMinutes     | Integer                       | The number of minutes after which the alert dialog window will automatically close.                                       |
| barkStartTime                  | String (format: "HH:mm")      | The start time of the day when the application should start sending alerts.                                               |
| barkEndTime                    | String (format: "HH:mm")      | The end time of the day when the application should stop sending alerts.                                                  |
| calendarsToExclude             | Array of objects              | A list of calendars to exclude from the meeting alerts. Each object has a `name` and an `id` property.                   |
| voiceOptions                   | Object                        | Configuration options for the text-to-speech voice alerts. See the nested properties below.                               |
| &emsp;using                    | String                        | The name of the voice to use (e.g., "Karen"). The available voices depend on your system and installed voices.            |
| &emsp;speakingRate             | Integer  | The speaking rate of the voice, in words per minute.             |
| &emsp;pitch                    | Float   | The pitch multiplier of the voice.                               |
| &emsp;volume                   | Float       | The volume of the voice, where 0.0 is mute, and 1.0 is the maximum volume.                                                |
| &emsp;waitForCompletion        | Boolean                       | Set to `true` if the application should wait for the voice to finish speaking before continuing, or `false` to allow the application to continue running while the voice speaks. |
| barkPool                       | Array of strings              | A list of URLs, spotify:uri entries, or text strings to play/speak as verbal alerts. If a YouTube or Spotify track is provided, it will end any further barking. |
| dialogWindowTextStages         | Array of strings              | The list of text messages to display in the alert dialog window, based on the urgency of the event.                       |
| intentionPrompts               | Array of strings              | A list of prompts/questions that the user can answer to help them focus on their intentions for the upcoming meeting.     |
