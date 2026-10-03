#!/usr/bin/env python3
"""Run only the shared Foundation policy with synthetic temporary files; never launch either app."""
import argparse
from pathlib import Path
import subprocess
import tempfile

START = '// BEGIN SHARED CALENDAR DISMISSAL CONTRACT'
END = '// END SHARED CALENDAR DISMISSAL CONTRACT'

def contract(path):
    text = path.read_text()
    return text[text.index(START):text.index(END) + len(END)]

parser = argparse.ArgumentParser()
parser.add_argument('--peer-source', type=Path)
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
source = root / 'FocusBear/Schedule/CalendarManager.swift'
if not source.exists():
    source = root / 'swift-app/Late No More/EventWarningManager.swift'
policy = contract(source)
if args.peer_source:
    assert policy == contract(args.peer_source), 'Shared contract copies differ'
harness = r'''
let zone = TimeZone(identifier: "Australia/Melbourne")!
let formatter = ISO8601DateFormatter()
let first = formatter.date(from: "2026-10-01T00:00:00Z")!
let next = formatter.date(from: "2026-10-02T00:00:00Z")!
let event = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "work", externalID: "provider", start: first)
let moved = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "work", externalID: "provider", start: next)
let otherCalendar = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "personal", externalID: "provider", start: first)
let changedLocalID = SharedCalendarDismissals.Identity(eventID: "other-id", calendarID: "work", externalID: "provider", start: first)
let unknown = SharedCalendarDismissals.Identity(eventID: "unknown", calendarID: "work", externalID: nil, start: first)
func snapshot(_ rules: [SharedCalendarDismissals.Rule], account: String = "synthetic-account", version: Int = SharedCalendarDismissals.SCHEMA_VERSION) -> SharedCalendarDismissals {
    .init(version: version, revision: UUID(), accountID: account, rules: rules)
}
let day = SharedCalendarDismissals.rule(event: event, day: first, zone: zone)
let series = SharedCalendarDismissals.rule(event: event, day: nil, zone: zone)
let hidden = snapshot([day])
assert(hidden.hides(event))
assert(hidden.hides(changedLocalID))
assert(!hidden.hides(moved))
assert(!hidden.hides(otherCalendar))
assert(!hidden.hides(unknown))
assert(snapshot([series]).hides(moved))
let overnight = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "work", externalID: "provider",
    start: formatter.date(from: "2026-10-01T13:30:00Z")!, end: formatter.date(from: "2026-10-01T14:30:00Z")!)
let secondDay = SharedCalendarDismissals.rule(event: overnight, day: next, zone: zone)
assert(snapshot([secondDay]).hides(overnight))
let endsAtMidnight = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "work", externalID: "provider",
    start: overnight.start, end: formatter.date(from: "2026-10-01T14:00:00Z")!)
assert(!snapshot([secondDay]).hides(endsAtMidnight))
let overnightMovedToSecondDay = SharedCalendarDismissals.Identity(eventID: "event", calendarID: "work", externalID: "provider",
    start: next, end: next.addingTimeInterval(3600))
assert(!snapshot([secondDay]).hides(overnightMovedToSecondDay))
assert(!snapshot([]).hides(event))
assert(!snapshot([], account: "").hides(event))
assert(!snapshot([day], account: "").isValid)
assert(!snapshot([day], version: 99).isValid)
assert(!snapshot(Array(repeating: day, count: SharedCalendarDismissals.MAXIMUM_RULES + 1)).isValid)
let invalidDay = SharedCalendarDismissals.Rule(eventID: "event", calendarID: "work", externalID: nil, scope: .day, day: "2026-99-99", timeZone: zone.identifier)
assert(!snapshot([invalidDay]).isValid)
assert(SharedCalendarDismissals.decode(Data(repeating: 0, count: SharedCalendarDismissals.MAXIMUM_BYTES + 1)) == nil)
assert(SharedCalendarDismissals.decode(Data("{}".utf8)) == nil)
let encoded = try JSONEncoder().encode(hidden)
assert(SharedCalendarDismissals.decode(encoded)?.hides(event) == true)
let url = URL(fileURLWithPath: CommandLine.arguments[1]).appendingPathComponent("bridge/dismissals.json")
try hidden.write(at: url)
assert(SharedCalendarDismissals.read(at: url)?.hides(event) == true)
let reset = snapshot([], account: "other-account")
try reset.write(at: url)
assert(SharedCalendarDismissals.read(at: url)?.hides(event) == false)
assert(SharedCalendarDismissals.read(at: url)?.accountID == "other-account")
try Data("invalid".utf8).write(to: url)
assert(SharedCalendarDismissals.read(at: url) == nil)
let target = url.deletingLastPathComponent().appendingPathComponent("target")
try encoded.write(to: target)
try FileManager.default.removeItem(at: url)
try FileManager.default.createSymbolicLink(at: url, withDestinationURL: target)
assert(SharedCalendarDismissals.read(at: url) == nil)
do { try hidden.write(at: url); assertionFailure("Must refuse symlink") } catch {}
print("24 shared policy and temporary-file checks passed")
'''
with tempfile.TemporaryDirectory(prefix='calendar-dismissal-policy-') as temporary:
    directory = Path(temporary)
    swift = directory / 'policy.swift'
    swift.write_text('import Foundation\n' + policy + '\n' + harness)
    subprocess.run(['swift', '-module-cache-path', str(directory / 'module-cache'), str(swift), temporary], check=True)
