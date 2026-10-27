//
//  LogFile.swift
//  Late No More
//
//  The debug log (LateNoMore_Logs.txt). Foundation only, so scripts/test-log-file.sh can compile and
//  test it on its own.
//

import Foundation

/// Appends whole lines to the debug log from any thread and caps its size.
///
/// Uncapped, the log reached 3.6 GB by 27 Oct 2026: the calendar check wrote every event of the day every
/// 10 seconds, and nothing ever trimmed the file. Lines also came out interleaved
/// (`12:35:26  - 2026-10-27 12:35:26 vent:- name: …`), because each line was written in several pieces
/// and the calendar check and the main thread logged at the same time.
final class LogFile {
    static let MAXIMUM_BYTES: UInt64 = 50 * 1024 * 1024
    /// The one older file kept beside the live one, so a report still has the stretch before a rotation.
    static let ROTATED_SUFFIX = ".previous"
    static let TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss"
    private static let QUEUE_LABEL = "com.focusbear.latenomore.log"
    private static let COPY_CHUNK_BYTES = 1024 * 1024
    private static let NEWLINE = UInt8(ascii: "\n")

    let maximumBytes: UInt64
    private let resolveURL: () -> URL?
    private let queue = DispatchQueue(label: QUEUE_LABEL)
    private let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = TIMESTAMP_FORMAT
        return formatter
    }()
    /// The live file's size as far as this process knows; read from disk on the first write.
    private var knownSize: UInt64?

    /// - Parameter url: where the log lives; asked on every write, because the app sets it during launch.
    init(maximumBytes: UInt64 = MAXIMUM_BYTES, url: @escaping () -> URL?) {
        self.maximumBytes = maximumBytes
        self.resolveURL = url
    }

    static func rotatedURL(for url: URL) -> URL {
        url.deletingLastPathComponent().appendingPathComponent(url.lastPathComponent + ROTATED_SUFFIX)
    }

    func append(_ text: String, at date: Date = Date()) {
        queue.sync {
            guard let url = resolveURL(),
                  let data = "\(timestampFormatter.string(from: date))  -  \(text)\n".data(using: .utf8) else { return }
            write(data, to: url)
        }
    }

    private func write(_ data: Data, to url: URL) {
        var size = knownSize ?? Self.fileSize(at: url)
        if size > 0, size + UInt64(data.count) > maximumBytes {
            rotate(url, size: size)
            size = 0
        }
        do {
            try Self.appendOrCreate(data, at: url)
            knownSize = size + UInt64(data.count)
        } catch {
            // The file may have been moved or deleted underneath us: measure it again next time.
            knownSize = nil
        }
    }

    /// Moves the live file aside. A file that grew far past the cap before rotation existed keeps only its
    /// last `maximumBytes`, from a line start, so the multi-gigabyte log doesn't linger as the older file.
    private func rotate(_ url: URL, size: UInt64) {
        let rotated = Self.rotatedURL(for: url)
        let manager = FileManager.default
        try? manager.removeItem(at: rotated)
        if size > maximumBytes, Self.copyTail(of: url, bytes: maximumBytes, to: rotated) {
            try? manager.removeItem(at: url)
            return
        }
        // Within the cap, or the tail couldn't be copied: keep the whole file, as the older one.
        try? manager.moveItem(at: url, to: rotated)
    }

    private static func appendOrCreate(_ data: Data, at url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else {
            try data.write(to: url)
            return
        }
        // The throwing FileHandle calls: the old seekToEndOfFile/write(_:) raise Objective-C exceptions
        // on an I/O error, which Swift can't catch, and that would abort the app.
        let handle = try FileHandle(forWritingTo: url)
        defer { try? handle.close() }
        try handle.seekToEnd()
        try handle.write(contentsOf: data)
    }

    private static func fileSize(at url: URL) -> UInt64 {
        ((try? FileManager.default.attributesOfItem(atPath: url.path))?[.size] as? NSNumber)?.uint64Value ?? 0
    }

    private static func copyTail(of source: URL, bytes: UInt64, to destination: URL) -> Bool {
        let partial = destination.appendingPathExtension(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: partial) }
        do {
            let input = try FileHandle(forReadingFrom: source)
            defer { try? input.close() }
            let size = try input.seekToEnd()
            try input.seek(toOffset: size > bytes ? size - bytes : 0)
            guard FileManager.default.createFile(atPath: partial.path, contents: nil) else { return false }
            let output = try FileHandle(forWritingTo: partial)
            defer { try? output.close() }
            var isAtLineStart = size <= bytes
            while let chunk = try input.read(upToCount: COPY_CHUNK_BYTES), !chunk.isEmpty {
                var piece = chunk
                if !isAtLineStart {
                    guard let newline = piece.firstIndex(of: NEWLINE) else { continue }
                    piece = piece[piece.index(after: newline)...]
                    isAtLineStart = true
                }
                try output.write(contentsOf: piece)
            }
            try FileManager.default.moveItem(at: partial, to: destination)
            return true
        } catch {
            return false
        }
    }
}

/// Lets a list that is logged on every check through only when it differs from the previous one.
struct ChangedListFilter {
    private var lastList: [String]?

    /// The list, when it changed since the previous call; nil when it's the same.
    mutating func changed(_ list: [String]) -> [String]? {
        guard list != lastList else { return nil }
        lastList = list
        return list
    }
}
