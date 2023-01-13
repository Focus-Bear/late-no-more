# Late No More

Checks local iCal via AppleScript & notifies about upcomingEvents meetings. This repo is for a piece of subfunctionality for the Late No More desktop app. To learn more, visit the [Focus Bear website] (https://focusbear.io).

## Setup

Clone this repo and run a

`npm install`

Edit config.js if defaults below aren't appropriate for your use case.

Then

`npm run start`

or for testing

`npm run test`

## How it works

There are two core cycles in play:

1. First is to check iCal and save all meetings occuring in the next 30 minutes to a local, in-memory list. This is goverened by **SLOW_NAP_DURATION_MINUTES**
2. Second is to check the upcomingEvents, in-memory list for any immiment meetings and notify. This is goverened by **quickNapDurationMinutes**

## Key variables

```const LOOK_AHEAD_MINUTES = 2, // how long before a meeting should I notify?
SLOW_NAP_DURATION_MINUTES = 5, // how often should I look for meetings in iCal?
quickNapDurationMinutes = 0.5, // how often should I check the in-memory list of upcomingEvents
PAUSE_BETWEEN_BARKS_SECONDS = 5, // how many seconds does each line of dialog have to itself
```
