# Late No More

Checks your macOS calendars & notifies about upcoming events and meetings. To download a binary, visit https://focusbear.io/en/late-no-more

![Screenshot](https://uploads-ssl.webflow.com/628f17fc227cdc10d90d9d44/64743b6a76590e82e072cecb_LNM4.jpg)


# Motivation from jeznag

I built Late No More because being late for meetings was becoming very problematic for me (I got fired from a job because of it). I have ADHD and it’s way too easy for me to see a notification for a calendar appointment, space out and then forget about the meeting for five minutes. Sometimes I hit Dismiss instead of Snooze and never show up to the meeting at all.

My experience is that most calendar apps aren’t built for an ADHD brain like mine. I decided to build a Mac app that would help me and hopefully other people show up on time.

Late-No-More gives you notifications that make sense.

A notification 15 minutes before to remind you to prepare: this one is easy to dismiss
A notification 2 minutes before to remind you to actually join the dang meeting - this one is not easy to dismiss
‍
As the time gets closer to the meeting, the notification gets more and more obnoxious. It changes colour and starts playing annoying motivating sound effects. The goal is to get you to join the meeting 2 minutes early.

Once you’re in the meeting, the app asks you to set an intention - what do you want to learn/share during this meeting?

I’ve gotta admit that not only am I frequently late for meetings, I’m also frequently multitasking/distracting. Reflecting on it, what’s the point of showing up for the meeting if I’m not going to be there mentally as well? I’ve started declining invites to irrelevant meetings with 50 people in them. If the purpose of the meeting is for me to absorb information, I’d rather listen back to the recording at 2x speed.

‍For the meetings that I do choose to attend, I want to give them my full attention: camera on, no other apps, listening intently. That’s really hard for my brain but it’s not impossible. It starts with aligning my motivation: why do I want to show up for the meeting? Hopefully it’s an engaging meeting. If not, that’s ok - I can treat it as an opportunity to train my focus muscle and use the tactics that work for me - clearing distractions from my desk, taking notes and sometimes playing with a fidget toy if I need to (“Busy hands, quiet mind” right?).

## Architecture

Late No More is a native macOS app in `swift-app/`. It reads your calendars through EventKit
(`CalendarManager.swift`), schedules the alerts in `EventWarningManager.swift`, and has the settings UI.
There is no Node.js part any more: the original Node/AppleScript alerting script was replaced by the
Swift implementation and removed from this repo.

## Local development

Open `swift-app/Late No More.xcodeproj` in Xcode and run the `Late No More` scheme, or build from the
command line:

```bash
xcodebuild -project "swift-app/Late No More.xcodeproj" -scheme "Late No More" -configuration Debug build
```

The installer package is built with the scripts in `swift-app/pkg/` (`1build.sh`, then `2build.sh`).

## How it works

There are two core cycles in play:

1. First is to check iCal and save all meetings occurring in the next specified minutes to a local, in-memory list. This is governed by checkCalendarFrequencyMinutes.
2. Second is to check the upcomingEvents, in-memory list for any imminent meetings and notify. This is governed by checkUpcomingFrequencySeconds.
3. Upon meetings, optionally set an intention & write notes.

## Configuration Options

Please see the Configuration Options section below for details on each setting.

### Example Configuration

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

### Configuration Options

The app saves its settings to `~/Library/Application Support/com.focusbear.latenomore/events.json`; edit them in the app's settings window. Refer to the Example Configuration section above for a full example.
| Setting | Type | Description |
| ------------------------------ | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| checkUpcomingLookAheadMinutes | Integer | The number of minutes to look ahead in the calendar for upcoming meetings. |
| checkCalendarFrequencyMinutes | Integer | The frequency in minutes at which the application checks the calendar for new events. |
| checkUpcomingFrequencySeconds | Integer | The frequency in seconds at which the application checks for upcoming meetings to alert the user. |
| pauseAfterBarkSeconds | Integer | The duration in seconds to pause between verbal alerts. |
| dialogWindowTimeoutMinutes | Integer | The number of minutes after which the alert dialog window will automatically close. |
| barkStartTime | String (format: "HH:mm") | The start time of the day when the application should start sending alerts. |
| barkEndTime | String (format: "HH:mm") | The end time of the day when the application should stop sending alerts. |
| calendarsToExclude | Array of objects | A list of calendars to exclude from the meeting alerts. Each object has a `name` and an `id` property. |
| voiceOptions | Object | Configuration options for the text-to-speech voice alerts. See the nested properties below. |
| &emsp;using | String | The name of the voice to use (e.g., "Karen"). The available voices depend on your system and installed voices. |
| &emsp;speakingRate | Integer | The speaking rate of the voice, in words per minute. |
| &emsp;pitch | Float | The pitch multiplier of the voice. |
| &emsp;volume | Float | The volume of the voice, where 0.0 is mute, and 1.0 is the maximum volume. |
| &emsp;waitForCompletion | Boolean | Set to `true` if the application should wait for the voice to finish speaking before continuing, or `false` to allow the application to continue running while the voice speaks. |
| barkPool | Array of strings | A list of URLs, spotify:uri entries, or text strings to play/speak as verbal alerts. If a YouTube or Spotify track is provided, it will end any further barking. |
| dialogWindowTextStages | Array of strings | The list of text messages to display in the alert dialog window, based on the urgency of the event. |
| intentionPrompts | Array of strings | A list of prompts/questions that the user can answer to help them focus on their intentions for the upcoming meeting. |

[To get a Spotify URI](https://community.spotify.com/t5/FAQs/What-s-a-Spotify-URI/ta-p/919201) TLDR: hold option/alt when going to share on desktop
