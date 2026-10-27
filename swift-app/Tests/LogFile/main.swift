//
//  main.swift
//  LogFile tests
//
//  The debug log (LogFile.swift). The app has no test target, so scripts/test-log-file.sh compiles this
//  with LogFile.swift alone and runs it.
//

import Foundation

private var failures: [String] = []

private func check(_ condition: Bool, _ name: String) {
    print("\(condition ? "PASS" : "FAIL") \(name)")
    if !condition { failures.append(name) }
}

private let manager = FileManager.default
private let directory = manager.temporaryDirectory.appendingPathComponent("lnm-log-tests-\(UUID().uuidString)")
try! manager.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? manager.removeItem(at: directory) }

private let LINE_PATTERN = #"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}  -  .+$"#

private func lines(at url: URL) -> [String] {
    ((try? String(contentsOf: url, encoding: .utf8)) ?? "").split(separator: "\n").map(String.init)
}

private func size(of url: URL) -> UInt64 {
    ((try? manager.attributesOfItem(atPath: url.path))?[.size] as? NSNumber)?.uint64Value ?? 0
}

// Lines logged at once from several threads come out whole, one per call.
let concurrentURL = directory.appendingPathComponent("concurrent.txt")
let concurrentLog = LogFile { concurrentURL }
let threads = 8, linesPerThread = 300
DispatchQueue.concurrentPerform(iterations: threads) { thread in
    for line in 0..<linesPerThread { concurrentLog.append("thread \(thread) line \(line) event:- name: Data/AI standup") }
}
let concurrentLines = lines(at: concurrentURL)
check(concurrentLines.count == threads * linesPerThread, "every line from \(threads) threads is written")
check(concurrentLines.allSatisfy { $0.range(of: LINE_PATTERN, options: .regularExpression) != nil },
      "no line is interleaved with another")

// The log rotates at the cap and keeps one older file.
let maximumBytes: UInt64 = 10_000
let rotatingURL = directory.appendingPathComponent("rotating.txt")
let rotatingLog = LogFile(maximumBytes: maximumBytes) { rotatingURL }
for line in 0..<1_000 { rotatingLog.append("line \(line)") }
let rotatedURL = LogFile.rotatedURL(for: rotatingURL)
check(size(of: rotatingURL) <= maximumBytes, "the live log stays under the cap")
check(size(of: rotatedURL) <= maximumBytes, "the older file stays under the cap")
check(lines(at: rotatingURL).last?.hasSuffix("line 999") == true, "the newest line is in the live log")
private func lineNumber(_ line: String?) -> Int? { line?.split(separator: " ").last.flatMap { Int($0) } }
check(lineNumber(lines(at: rotatedURL).last).map { $0 + 1 } == lineNumber(lines(at: rotatingURL).first),
      "the older file ends just before the live log begins")
let filesAfterRotation = try! manager.contentsOfDirectory(atPath: directory.path).filter { $0.hasPrefix("rotating") }
check(Set(filesAfterRotation) == ["rotating.txt", "rotating.txt\(LogFile.ROTATED_SUFFIX)"], "only one older file is kept")

// A log that grew uncapped before rotation existed (3.6 GB on 27 Oct 2026) keeps only its last stretch.
let legacyURL = directory.appendingPathComponent("legacy.txt")
let legacyLine = { (number: Int) in "2026-10-27 12:44:29  -  legacy line \(number)\n" }
let legacyText = (0..<20_000).map(legacyLine).joined()
try! legacyText.write(to: legacyURL, atomically: true, encoding: .utf8)
try! "stale older file\n".write(to: LogFile.rotatedURL(for: legacyURL), atomically: true, encoding: .utf8)
let legacyCap: UInt64 = 64 * 1024
check(size(of: legacyURL) > 10 * legacyCap, "the legacy log starts more than ten times over the cap")
let legacyLog = LogFile(maximumBytes: legacyCap) { legacyURL }
legacyLog.append("func:- startCheck")
let legacyRotated = lines(at: LogFile.rotatedURL(for: legacyURL))
check(size(of: LogFile.rotatedURL(for: legacyURL)) <= legacyCap, "the oversized log's older file is cut to the cap")
check(legacyRotated.first?.range(of: LINE_PATTERN, options: .regularExpression) != nil, "it starts at a whole line")
check(legacyRotated.last == legacyLine(19_999).trimmingCharacters(in: .newlines), "it ends with the legacy log's last line")
check(!legacyRotated.contains("stale older file"), "it replaces the previous older file")
check(lines(at: legacyURL).count == 1 && lines(at: legacyURL)[0].hasSuffix("func:- startCheck"),
      "the live log starts afresh with the new line")

// A log deleted underneath the app is recreated.
try! manager.removeItem(at: legacyURL)
legacyLog.append("after deletion")
check(lines(at: legacyURL).last?.hasSuffix("after deletion") == true, "a deleted log is recreated on the next line")

// The day's event list is logged only when it changes.
var filter = ChangedListFilter()
let morning = ["event:- name: Data/AI standup", "event:- name: UX checkin"]
check(filter.changed(morning) == morning, "the first list is logged")
check(filter.changed(morning) == nil, "the same list isn't logged again")
check(filter.changed(Array(morning.dropFirst())) == ["event:- name: UX checkin"], "a changed list is logged")
check(filter.changed([]) == [], "an empty day is logged once")
check(filter.changed([]) == nil, "and not again")

if failures.isEmpty {
    print("LogFile: all checks passed")
} else {
    print("\(failures.count) failed")
    exit(1)
}
