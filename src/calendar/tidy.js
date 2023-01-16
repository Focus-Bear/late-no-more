function tidyDate(date) {
    return new Date(date.split(',').slice(1).join(',').replace(' at', ''))
}

function matchService(evt) {
    const { description } = evt

    const isGoogleMeet = description?.includes('google.com'),
        isMsftTeams = description?.includes('microsoft.com')

    if (isMsftTeams || isGoogleMeet) {
        const regex = /https\S*[\s\>]/,
            [url] = description.match(regex)
        return { ...evt, url: url.trim() }
    }
    return evt
}

function tidyEvent(evt, type = 'default') {
    const tidy = evt.map((field) => {
        if (field == 'missing value') return null
        return field
    })

    const [summary, start, end, url, loc, desc, id, calName] = tidy

    const obj = {
        summary,
        calendarName: calName,
        startDate: tidyDate(start),
        endDate: tidyDate(end),
        location: loc,
        description: desc,
        url,
        type,
        id,
    }
    return matchService(obj)
}

module.exports = { tidyEvent, matchService }
