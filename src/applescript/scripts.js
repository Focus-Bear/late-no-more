const SCRIPT_HEADER = `
		use AppleScript version \"2.4\" -- Yosemite (10.10) or later
	   	use framework \"Foundation\"
	   	use scripting additions
	   	use script \"CalendarLib EC\" version \"1.1.4\"

		set theStore to fetch store
	 `   
const properties = [
        'event_summary',
        'event_start_date',
        'event_end_date',
        'event_url',
        'event_location',
        'event_description',
        'event_external_ID',
        'calendar_name',
    ]   
function createParseStatements(props) {
	return props.map(prop => `copy ${prop} of (event info for event anEvent) as text to end of current`).join("\n")
}

const GET_ALL_EVENTS = `
        set theCals to fetch calendars {} event store theStore
		set start_of_checking_window to (current date)
		set end_of_checking_window to start_of_checking_window + 1 * hours
		set theEvents to fetch events starting date start_of_checking_window ending date end_of_checking_window searching cals theCals event store theStore

		set output to {}

		repeat with anEvent in theEvents
			set startTime to event_start_date of (event info for event anEvent)
			set current to {}
			if (startTime ≥ start_of_checking_window) and (startTime ≤ end_of_checking_window) then
				try
					${createParseStatements(properties)}	
					copy current to end of output
				on error errMsg
					display dialog errMsg
				end try
			end if
		end repeat
		return output
`,
    GET_ALL_CALENDARS = `
	    set theCals to fetch calendars {} event store theStore 
		set theTitles to {}
		repeat with aCal in theCals
	      set calTitle to aCal's title() as text
		  set theTitles to theTitles & calTitle   
		end repeat

		return theTitles`

module.exports = { SCRIPT_HEADER, GET_ALL_EVENTS, GET_ALL_CALENDARS }
