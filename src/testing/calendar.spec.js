const { matchService } = require('../calendar/tidy')

const testCases =
    [
        {
            calendarData: { "summary": "Performance Review", "calendarName": "Calendar", "startDate": "2023-01-13T05:30:00.000Z", "endDate": "2023-01-13T05:45:00.000Z", "location": null, "description": "\r\n________________________________________________________________________________\r\nMicrosoft Teams meeting\r\nJoin on your computer or mobile app\r\nClick here to join the meeting<https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZmYwYTY4YjctMzMxMi00MmU5LWFjYTAtNjMwMzE5NzM4Y2Fl%40thread.v2/0?context=%7b%22Tid%22%3a%223b518aae-8921-4a7b-8497-619d756ce20e%22%2c%22Oid%22%3a%22b97e1b4b-edb5-48eb-a783-b64a66a55333%22%7d>\r\nOr call in (audio only)\r\n+1 412-912-4129,,758276296#<tel:+14129124129,,758276296#>   United States, Pittsburgh\r\nPhone Conference ID: 758 276 296#\r\nFind a local number<https://dialin.teams.microsoft.com/9b869321-e683-4bf6-ac06-e2c52d67cb9a?id=758276296> | Reset PIN<https://mysettings.lync.com/pstnconferencing>\r\nLearn more<https://aka.ms/JoinTeamsMeeting> | Meeting options<https://teams.microsoft.com/meetingOptions/?organizerId=dca1ad50-1d0d-449f-a28d-8929ffbf7eaa&tenantId=4ae1b72f-a288-4b5d-98ad-dbe05c630a89&threadId=19_meeting_ZmYwYTY4YjctMzMxMi00MmU5LWFjYTAtNjMwMzE5NzM4Y2Fl@thread.v2&messageId=0&language=en-GB>\r\n________________________________________________________________________________\r\n", "url": "https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZmYwYTY4YjctMzMxMi00MmU5LWFjYTAtNjMwMzE5NzM4Y2Fl%40thread.v2/0?context=%7b%22Tid%22%3a%223b518aae-8921-4a7b-8497-619d756ce20e%22%2c%22Oid%22%3a%22b97e1b4b-edb5-48eb-a783-b64a66a55333%22%7d>", "id": "BD834825-C84B-48EB-9B3E-5B531ED15F6D" },
            expectedUrl: 'https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZmYwYTY4YjctMzMxMi00MmU5LWFjYTAtNjMwMzE5NzM4Y2Fl%40thread.v2/0?context=%7b%22Tid%22%3a%223b518aae-8921-4a7b-8497-619d756ce20e%22%2c%22Oid%22%3a%22b97e1b4b-edb5-48eb-a783-b64a66a55333%22%7d',

        }
    ];

describe('matchService', () => {
    testCases.forEach((testCase) => {
        it('should return the correct url', () => {
            const actualResult = matchService(testCase.calendarData);

            expect(actualResult.url).toEqual(testCase.expectedUrl);
        })
    })
})
