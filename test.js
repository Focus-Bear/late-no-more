const events = [
    {
        summary: 'Edward Jeremy workout',
        calendarName: 'jeremymnagel@gmail.com',
        startDate: '2023-01-08T23:00:00.000Z',
        endDate: '2023-01-09T00:00:00.000Z',
        location: null,
        description:
            '-:::::::::::::::::::::::::::::::::::::::::::::-\nJoin with Google Meet: https://meet.google.com/hmj-gtrg-wyy\n\nLearn more about Meet at: https://support.google.com/a/users/answer/9282720\n\nPlease do not edit this section.\n-:::::::::::::::::::::::::::::::::::::::::::::-',
        url: null,
        id: 'http://f96kpd4goaqmjjkvqgvmq70tk2_R20220702T070000@google.com/RID=694764000',
    },
    {
        summary: 'Fred Jeremy regular 1 on 1',
        calendarName: 'Calendar',
        startDate: '2023-01-06T05:45:00.000Z',
        endDate: '2023-01-06T06:00:00.000Z',
        location: null,
        description:
            '\r\n________________________________________________________________________________\r\nMicrosoft Teams meeting\r\nJoin on your computer, mobile app or room device\r\nClick here to join the meetinghttps://teams.microsoft.com/l/meetup-join/19%3ameeting_ZTYxMTA2ZDEtN2VhMy00ZWNmLTkzNDAtZDAwODNjYTlkYTJi%40thread.v2/0?context=%7b%22Tid%22%3a%223b518aae-8921-4a7b-8497-619d756ce20e%22%2c%22Oid%22%3a%22b97e1b4b-edb5-48eb-a783-b64a66a55333%22%7d\r\nMeeting ID: 349 356 012 586\r\nPasscode: FVxM7N\r\nDownload Teamshttps://www.microsoft.com/en-us/microsoft-teams/download-app | Join on the webhttps://www.microsoft.com/microsoft-teams/join-a-meeting\r\nLearn morehttps://aka.ms/JoinTeamsMeeting | Meeting optionshttps://teams.microsoft.com/meetingOptions/?organizerId=b97e1b4b-edb5-48eb-a783-b64a66a55333tenantId=3b518aae-8921-4a7b-8497-619d756ce20ethreadId=19_meeting_ZTYxMTA2ZDEtN2VhMy00ZWNmLTkzNDAtZDAwODNjYTlkYTJi@thread.v2messageId=0language=en-GB\r\n________________________________________________________________________________\r\n',
        url: null,
        id: 'F2DBD832-EF8B-4608-93F2-C000EC1B9ABA',
    },
]

const { matchServices } = require('./src/applescript/calendar')

for (const event of events) {
    console.log(matchServices(event))
}
