//
//  ViewController.swift
//  Late No More
//
//  Created by Prashant Sawnani on 20/12/22.
//

import Cocoa
import EventKit
import SwiftUI

/// Keys of events.json, shared with the Node engine and every existing user's file.
private enum SettingsFileKey {
    static let calendarsToExclude = "calendarsToExclude"
    static let calendarName = "name"
    static let calendarID = "id"
    static let eventKeywordsToIgnore = "eventKeywordsToIgnore"
    static let barkStartTime = "barkStartTime"
    static let barkEndTime = "barkEndTime"
    static let voiceOptions = "voiceOptions"
    static let voiceUsing = "using"
    static let voiceSpeakingRate = "speakingRate"
    static let voicePitch = "pitch"
    static let voiceVolume = "volume"
    static let voiceModulation = "modulation"
    static let barkPool = "barkPool"
    static let dialogWindowTextStages = "dialogWindowTextStages"
    static let intentionPrompts = "intentionPrompts"
}

/// Keys the warning manager reads from each calendar entry.
private enum CalendarEntryKey {
    static let name = "name"
    static let state = "state"
    static let id = "id"
    static let calendar = "calendar"
}

private enum AnalyticsEvent: String {
    case openAdvancedSettings = "open-advanced-settings"
    case modifyExcludedCalendarList = "modify-excluded-calendar-list"
    case applySettings = "apply-settings"
}

private enum SettingsDefaults {
    static let preferredVoice = "Karen"
    static let speakingRate: Float = 150
    static let pitch: Float = 50
    static let volume: Float = 0.5
    static let modulation = 2
    static let ignoredKeywords = ["no-notify"]
    static let alertStartTime = TimeOfDay(hour: 7, minute: 0)!
    static let alertEndTime = TimeOfDay(hour: 21, minute: 0)!
    static let pitchRange: ClosedRange<Float> = 0.5...2
    static let fallbackPitch: Float = 1.2
    static let maxSpeakingRate: Float = 1
    static let fallbackSpeakingRate: Float = 0.4
    static let maxVolume: Float = 1
}

private let FOCUS_BEAR_URL = URL(string: "https://focusbear.io")!
private let ADVANCED_SETTINGS_SCENE = NSStoryboard.SceneIdentifier("advancedSettingsVc")
private let RESTART_HOT_KEY = "l"
/// The settings flow has always waited this long before (re)starting the checker.
private let CHECKER_START_DELAY_SECONDS: UInt32 = 1

class ViewController: NSViewController {
    private lazy var eventStore = EKEventStore()
    private var eventCalendars = [EKCalendar]()
    private var settingsModel: SettingsViewModel?
    private var advancedSettingsVcObj: advancedSettingsVc?
    private var warningManagerObject = EventWarningManager()
    private var isFirstAppearance = true

    override func viewDidLoad() {
        super.viewDidLoad()
        addLog(text: "viewDidLoad")

        textToSpeechObject.listVoices() // fills arrVoiceNames
        applyDefaultVoiceOptions()

        eventCalendars = eventStore.calendars(for: .event)
        addLog(text: "got Calenders from eventStore")

        let storedSettings = readSettingsFile()
        applyAdvancedSettings(from: storedSettings)

        hotKeyRestartApp = HotKey(keyCombo: KeyCombo(stkey: RESTART_HOT_KEY, modifiers: [.shift, .command]))
        embedSettingsView(settings: alertSettings(from: storedSettings), launchesAtLogin: restoreLaunchAtLogin())
        observeSheetsAndTermination()
    }

    override func viewDidAppear() {
        addLog(text: "func:- viewDidAppear")
        guard isFirstAppearance, let settings = settingsModel?.settings else { return }
        isFirstAppearance = false
        writeSettingsFile(settings)
        DispatchQueue.global().async {
            sleep(CHECKER_START_DELAY_SECONDS)
            DispatchQueue.main.async { self.launchProcess() }
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        settingsModel?.saveNowIfChanged()
    }

    var hotKeyRestartApp: HotKey? {
        didSet {
            hotKeyRestartApp?.keyDownHandler = { [weak self] in
                addLog(text: "shortcut clicked")
                DispatchQueue.global().async {
                    sleep(CHECKER_START_DELAY_SECONDS)
                    DispatchQueue.main.async { self?.launchProcess() }
                }
            }
        }
    }

    func launchProcess() {
        guard let settings = settingsModel?.settings else { return }
        updateWarningManager(with: settings)
        warningManagerObject.startCheck()
    }

    // MARK: - Settings view

    private func embedSettingsView(settings: AlertSettings, launchesAtLogin: Bool) {
        let model = SettingsViewModel(
            calendars: eventCalendars.map(calendarOption),
            settings: settings,
            launchesAtLogin: launchesAtLogin,
            versionDescription: appVersion,
            persist: { [weak self] settings, previous in self?.apply(settings, replacing: previous) },
            onLaunchAtLoginChange: { isOn in
                UserDefaults.standard.set(isOn, forKey: kUserdefaultsLaunchAtLogin)
                LaunchOnStartup.setLaunchAtStartup(isOn)
            }
        )
        settingsModel = model

        let hostingView = NSHostingView(rootView: SettingsView(
            model: model,
            onOpenAdvanced: { [weak self] in self?.openAdvancedSettings() },
            onOpenWebsite: { [weak self] in self?.openFocusBearWebsite() }
        ))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func calendarOption(for calendar: EKCalendar) -> CalendarOption {
        let color = calendar.color.usingColorSpace(.sRGB).map {
            CalendarColor(red: Double($0.redComponent), green: Double($0.greenComponent), blue: Double($0.blueComponent))
        }
        return CalendarOption(
            id: calendar.calendarIdentifier,
            title: calendar.title,
            accountTitle: calendar.source?.title ?? "",
            color: color
        )
    }

    private func apply(_ settings: AlertSettings, replacing previous: AlertSettings) {
        addLog(text: "settings changed, saving")
        if settings.enabledCalendarIDs != previous.enabledCalendarIDs {
            capturePosthog(event: AnalyticsEvent.modifyExcludedCalendarList.rawValue, metadata: [:])
        }
        capturePosthog(event: AnalyticsEvent.applySettings.rawValue, metadata: [:])
        writeSettingsFile(settings)
        // The checker reads its calendars and hours on every tick, so new values need no restart.
        updateWarningManager(with: settings)
    }

    private func updateWarningManager(with settings: AlertSettings) {
        warningManagerObject.resetData(
            calendars: calendarEntries(enabledIDs: settings.enabledCalendarIDs),
            startTime: settings.alertStartTime.date(),
            endTime: settings.alertEndTime.date()
        )
    }

    private func calendarEntries(enabledIDs: Set<String>) -> [[String: Any]] {
        eventCalendars.map { calendar in
            [
                CalendarEntryKey.name: calendar.title,
                CalendarEntryKey.state: enabledIDs.contains(calendar.calendarIdentifier),
                CalendarEntryKey.id: calendar.calendarIdentifier,
                CalendarEntryKey.calendar: calendar,
            ]
        }
    }

    // MARK: - Actions

    private func openFocusBearWebsite() {
        addLog(text: "btnCheckOutClicked")
        NSWorkspace.shared.open(FOCUS_BEAR_URL)
    }

    private func openAdvancedSettings() {
        addLog(text: "button advanced clicked")
        capturePosthog(event: AnalyticsEvent.openAdvancedSettings.rawValue, metadata: [:])
        if advancedSettingsVcObj == nil {
            advancedSettingsVcObj = mainStoryboard.instantiateController(withIdentifier: ADVANCED_SETTINGS_SCENE) as? advancedSettingsVc
        }
        guard let advancedSettings = advancedSettingsVcObj else { return }
        presentAsSheet(advancedSettings)
    }

    private func observeSheetsAndTermination() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(sheetDidEnd(_:)), name: NSWindow.didEndSheetNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(applicationWillTerminate(_:)),
            name: NSApplication.willTerminateNotification, object: nil)
    }

    /// The Advanced sheet edits globals this window doesn't track, so they are saved when it closes.
    @objc private func sheetDidEnd(_ notification: Notification) {
        guard let window = notification.object as? NSWindow, window == view.window,
              let settings = settingsModel?.settings else { return }
        addLog(text: "advanced settings closed, saving")
        capturePosthog(event: AnalyticsEvent.applySettings.rawValue, metadata: [:])
        writeSettingsFile(settings)
    }

    @objc private func applicationWillTerminate(_ notification: Notification) {
        settingsModel?.saveNowIfChanged()
    }

    // MARK: - Launch at login

    private func restoreLaunchAtLogin() -> Bool {
        let isOn = UserDefaults.standard.object(forKey: kUserdefaultsLaunchAtLogin) as? Bool ?? true
        UserDefaults.standard.set(isOn, forKey: kUserdefaultsLaunchAtLogin)
        LaunchOnStartup.setLaunchAtStartup(isOn)
        return isOn
    }

    // MARK: - Settings file

    private func readSettingsFile() -> NSDictionary? {
        guard let url = jsonUrl, let data = try? Data(contentsOf: url, options: .mappedIfSafe) else {
            addLog(text: "Failed to Read events.json file")
            return nil
        }
        addLog(text: "Got Data from events.json")
        guard let json = (try? JSONSerialization.jsonObject(with: data)) as? NSDictionary else {
            addLog(text: "Failed to Read Json file form data")
            return nil
        }
        addLog(text: "Got Json from events.json data")
        return json
    }

    private func alertSettings(from json: NSDictionary?) -> AlertSettings {
        let excludedIDs = (json?[SettingsFileKey.calendarsToExclude] as? [NSDictionary] ?? [])
            .compactMap { $0[SettingsFileKey.calendarID] as? String }
        return AlertSettings(
            enabledCalendarIDs: CalendarExclusions.enabledIDs(
                of: eventCalendars.map(calendarOption), excludedIDs: Set(excludedIDs)),
            ignoredKeywords: json?[SettingsFileKey.eventKeywordsToIgnore] as? [String] ?? SettingsDefaults.ignoredKeywords,
            alertStartTime: storedTime(json?[SettingsFileKey.barkStartTime]) ?? SettingsDefaults.alertStartTime,
            alertEndTime: storedTime(json?[SettingsFileKey.barkEndTime]) ?? SettingsDefaults.alertEndTime
        )
    }

    private func storedTime(_ value: Any?) -> TimeOfDay? {
        (value as? String).flatMap(TimeOfDay.init(storageString:))
    }

    private func applyDefaultVoiceOptions() {
        if !arrVoiceNames.isEmpty {
            usingValue = arrVoiceNames.keys.contains(SettingsDefaults.preferredVoice)
                ? SettingsDefaults.preferredVoice
                : arrVoiceNames.first?.key ?? ""
        }
        speakingRateValue = SettingsDefaults.speakingRate
        pitchValue = SettingsDefaults.pitch
        volumeValue = SettingsDefaults.volume
        modulationValue = SettingsDefaults.modulation
    }

    private func applyAdvancedSettings(from json: NSDictionary?) {
        if let voiceOptions = json?[SettingsFileKey.voiceOptions] as? NSDictionary {
            applyVoiceOptions(voiceOptions)
        }
        if let barkPool = json?[SettingsFileKey.barkPool] as? [String] {
            arrBarkPools = barkPool
        }
        if let textStages = json?[SettingsFileKey.dialogWindowTextStages] as? [String] {
            arrTextStages = textStages
        }
        if let intentionPrompts = json?[SettingsFileKey.intentionPrompts] as? [String] {
            arrIntentionPrompts = intentionPrompts
        }
    }

    private func applyVoiceOptions(_ voiceOptions: NSDictionary) {
        usingValue = voiceOptions[SettingsFileKey.voiceUsing] as? String ?? usingValue
        speakingRateValue = voiceOptions[SettingsFileKey.voiceSpeakingRate] as? Float ?? speakingRateValue
        pitchValue = voiceOptions[SettingsFileKey.voicePitch] as? Float ?? pitchValue
        volumeValue = voiceOptions[SettingsFileKey.voiceVolume] as? Float ?? volumeValue
        modulationValue = voiceOptions[SettingsFileKey.voiceModulation] as? Int ?? modulationValue

        // Values on the Node engine's scales (README: pitch 0–100, rate in words per minute) are out of
        // range for the speech synthesiser.
        if !SettingsDefaults.pitchRange.contains(pitchValue) {
            pitchValue = SettingsDefaults.fallbackPitch
        }
        if speakingRateValue > SettingsDefaults.maxSpeakingRate {
            speakingRateValue = SettingsDefaults.fallbackSpeakingRate
        }
        volumeValue = min(volumeValue, SettingsDefaults.maxVolume)
    }

    private func writeSettingsFile(_ settings: AlertSettings) {
        addLog(text: "func:- saveSettings")
        let excluded = CalendarExclusions
            .excluded(from: eventCalendars.map(calendarOption), enabledIDs: settings.enabledCalendarIDs)
            .map { [SettingsFileKey.calendarName: $0.name, SettingsFileKey.calendarID: $0.id] }
        let voiceOptions: NSDictionary = [
            SettingsFileKey.voiceUsing: usingValue,
            SettingsFileKey.voiceSpeakingRate: speakingRateValue,
            SettingsFileKey.voicePitch: pitchValue,
            SettingsFileKey.voiceVolume: volumeValue,
            SettingsFileKey.voiceModulation: modulationValue,
        ]
        let json: NSDictionary = [
            SettingsFileKey.calendarsToExclude: excluded,
            SettingsFileKey.eventKeywordsToIgnore: settings.ignoredKeywords,
            SettingsFileKey.barkStartTime: settings.alertStartTime.storageString,
            SettingsFileKey.barkEndTime: settings.alertEndTime.storageString,
            SettingsFileKey.voiceOptions: voiceOptions,
            SettingsFileKey.barkPool: arrBarkPools,
            SettingsFileKey.dialogWindowTextStages: arrTextStages,
            SettingsFileKey.intentionPrompts: arrIntentionPrompts,
        ]

        addLog(text: "Save events.json start")
        guard let url = jsonUrl,
              let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
        else {
            addLog(text: "Failure: convert data from json")
            return
        }
        do {
            try jsonString.write(to: url, atomically: true, encoding: .utf8)
            addLog(text: "Success: write json file:- \(jsonString)")
        } catch {
            addLog(text: "Failure: write json file")
        }
    }
}
