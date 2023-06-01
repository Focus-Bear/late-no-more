//
//  ViewController.swift
//  Late No More
//
//  Created by Prashant Sawnani on 20/12/22.
//

import Cocoa
import EventKit
//import Speech

class ViewController: NSViewController, NSTokenFieldDelegate {

    
    @IBOutlet weak var btnAdvanced: NSButton!
    @IBOutlet weak var pickerEndTime: NSDatePicker!
    @IBOutlet weak var pickerStartTime: NSDatePicker!
    @IBOutlet weak var lblEndTime: NSTextField!
    @IBOutlet weak var lblStartTime: NSTextField!
    @IBOutlet weak var lblTitleWorkTime: NSTextField!
    @IBOutlet weak var btnCheckOut: NSButton!
    @IBOutlet weak var lblBottom: NSTextField!
    @IBOutlet weak var btnApply: NSButton!
    @IBOutlet weak var lblTitleEvents: NSTextField!
    @IBOutlet weak var lblTitleCalendar: NSTextField!
    @IBOutlet weak var tokenField: NSTokenField!
    @IBOutlet weak var tblViewCalendar: NSTableView!
    var arrCalendars = [[String:Any]]()
    var advancedSettingsVcObj:advancedSettingsVc?
    var isCalendarListEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLog(text: "viewDidLoad")
        
//        let speechSynth = NSSpeechSynthesizer()
        let voices = NSSpeechSynthesizer.availableVoices
        
        
        for voice in voices{
            let attributes = NSSpeechSynthesizer.attributes(forVoice: voice)
            let name = attributes[.name] as? String ?? "Unknown"
            let language = attributes[.localeIdentifier] as? String ?? "Unknown"
            print(name)
            print(voice.rawValue)
            print(language)
            arrVoiceNames.append(name)
        }
        if arrVoiceNames.count !=  0{
            if arrVoiceNames.contains("Karen"){
                usingValue = "Karen"
            }else{
                usingValue = arrVoiceNames.first ?? ""
            }
        }
        speakingRateValue = 150
        pitchValue = 50
        volumeValue = 0.5
        modulationValue = 2
        
        btnAdvanced.title = "Advanced"
        
        pickerStartTime.dateValue = getDateFromString(date: "7:00", dateFormat: "HH:mm") ?? Date()
        pickerEndTime.dateValue = getDateFromString(date: "21:00", dateFormat: "HH:mm") ?? Date()
        
        
        
        lblStartTime.stringValue = "Start Time:"
        lblEndTime.stringValue = "End Time:"
        
        
        lblTitleWorkTime.stringValue = "What hours do you want to get verbal alerts?"
        
        lblBottom.stringValue = "Late No More is brought to you by Focus Bear, a holistic productivity and habit formation app."
        btnApply.title = "Apply"
        lblTitleCalendar.stringValue = "Which calendars do you want to get notifications for?"
        lblTitleEvents.stringValue = "What calendar events do you not want to get notifications for? Choose keywords to ignore:"

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = btnCheckOut.alignment
        paragraph.lineBreakMode = .byTruncatingTail
        let attrs = [NSAttributedString.Key.foregroundColor: NSColor.labelColor, NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        let attrString: NSAttributedString = NSAttributedString(string: "Check it out at focusbear.io", attributes: attrs)
        btnCheckOut.attributedTitle = attrString
        
        
        //        let calendars = EventStore.calendars(for entityType:.Events)
        let eventStore = EKEventStore()
        
        
        
        
        
        let calendars = eventStore.calendars(for: .event)
        for calendar in calendars {
            arrCalendars.append(["name":calendar.title, "state": true, "id":calendar.calendarIdentifier])
        }
        print(arrCalendars)
        tokenField.objectValue = ["no-notify"]
        
        addLog(text: "got Calenders from eventStore")
        
        do {
            let data = try Data(contentsOf: jsonUrl!, options: .mappedIfSafe)
            //  if data != nil{
            addLog(text: "Got Data from events.json")
            
            do {
                if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                    print(jsonResult)
                    
                    addLog(text: "Got Json from events.json data")
                    if let calendarsToExclude = jsonResult.value(forKey: "calendarsToExclude") as? [NSDictionary]{
                        for i in 0..<arrCalendars.count {
                            let calendar = arrCalendars[i]
                            if let id = calendar["id"] as? String{
                                
                                for excludeCalendar in calendarsToExclude {
                                    if let savedId = excludeCalendar["id"] as? String{
                                        if id == savedId{
                                            arrCalendars[i]["state"] = false
                                            break;
                                        }

                                    }
                                }

                            }
                        }
                    }
                    if let eventKeywordsToIgnore = jsonResult.value(forKey: "eventKeywordsToIgnore") as? [String]{
                        tokenField.objectValue = eventKeywordsToIgnore
                    }
                    
                    if let barkStartTime = jsonResult.value(forKey: "barkStartTime") as? String{
                        pickerStartTime.dateValue = getDateFromString(date: barkStartTime, dateFormat: "HH:mm") ?? Date()
                    }
                    if let barkEndTime = jsonResult.value(forKey: "barkEndTime") as? String{
                        pickerEndTime.dateValue = getDateFromString(date: barkEndTime, dateFormat: "HH:mm") ?? Date()
                    }
                    
                    if let voiceOptions = jsonResult.value(forKey: "voiceOptions") as? NSDictionary{
                        usingValue = voiceOptions.value(forKey: "using") as? String ?? usingValue
                        speakingRateValue = voiceOptions.value(forKey: "speakingRate") as? Int ?? speakingRateValue
                        pitchValue = voiceOptions.value(forKey: "pitch") as? Int ?? pitchValue
                        volumeValue = voiceOptions.value(forKey: "volume") as? Float ?? volumeValue
                        modulationValue = voiceOptions.value(forKey: "modulation") as? Int ?? modulationValue
                    }
                    
                    if let barkPool = jsonResult.value(forKey: "barkPool") as? [String]{
                        arrBarkPools  = barkPool
                    }
                    
                    if let dialogWindowTextStages = jsonResult.value(forKey: "dialogWindowTextStages") as? [String]{
                        arrTextStages  = dialogWindowTextStages
                    }
                    
                    if let intentionPrompts = jsonResult.value(forKey: "intentionPrompts") as? [String]{
                        arrIntentionPrompts  = intentionPrompts
                    }
                }
            }catch{
                addLog(text: "Failed to Read Json file form data")
                print(error)
            }
            //  }
        } catch {
            // handle error
            addLog(text: "Failed to Read events.json file")
        }
        
        
        
        
        
        
        
//        let start_time = Date()
//        let calendar = Calendar.current
//        let finish_time = calendar.date(byAdding: .year, value: 1, to: start_time) ?? Date()
//
//        let predicate = eventStore.predicateForEvents(withStart: Date(), end: finish_time, calendars: [arrCalendars[1]])//nil will include all the calendars
//
//        let events = eventStore.events(matching: predicate) as [EKEvent]
//        print(events)
        
        
        
        
//        let eventStore = EventsManager.getEventStore()
//
////        NSAppleEventManager
//
//        var tempArray:[EKEvent] = []
//
//
//
//        let predicate = eventStore.predicateForEvents(withStart: startdate, end: endDate, calendars: calendars)//nil will include all the calendars
//
//        let events = eventStore.events(matching: predicate) as [EKEvent]
        let char = "l"
        var flags = NSEvent.modifierFlags
        flags.insert(.shift)
        flags.insert(.command)
        hotKeyRestartApp = HotKey(keyCombo: KeyCombo(stkey: char, modifiers: flags))
        
        tokenField.delegate = self
    }
    var hotKeyRestartApp: HotKey? {
        didSet {
            guard let hotKey = hotKeyRestartApp else {
                return
            }
            hotKey.keyDownHandler = { [weak self] in
                print("Pressed at \(Date())")
                addLog(text: "shortcut clicked")
                terminateProcess()
                DispatchQueue.global().async {
                    sleep(1)
                    DispatchQueue.main.async {
//                        NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/LateNoMore"))
                        self?.launchProcess()
                    }
                }
            }
        }
    }
    
    var firstTime = true

    override func viewDidAppear() {
        addLog(text: "func:- viewDidAppear")
        if firstTime{
            firstTime = false
            saveSettings()
            DispatchQueue.global().async {
                sleep(1)
                DispatchQueue.main.async {
                    addLog(text: "open LateNoMore process after file save")
//                    NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/LateNoMore"))

                    self.launchProcess()

                    
                    
                }
            }
        }
    }
    func launchProcess(){
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "launchctl asuser \"$(id -u)\" \"\(helperAppUrl!.path)\""]
        task.launch()
        capturePosthog(event: "start-late-no-more-binary", metadata: [:])
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func btnCheckOutClicked(_ sender: Any) {
        addLog(text: "btnCheckOutClicked")
        let buynow_path = "https://focusbear.io"
        NSWorkspace.shared.open(URL(string: buynow_path)!)
    }
//    @IBAction func tokenFieldClicked(_ sender: Any) {
//
//    }
    
    func saveSettings(){
        
        addLog(text: "func:- saveSettings")
        terminateProcess()
        
        var events = [String]()
        if let objectValue = tokenField.objectValue as? [String] {
            events = objectValue
        }
        var calendarsToExclude = [NSDictionary]()
        for calendar in arrCalendars {
            if let state = calendar["state"] as? Bool{
                if !state{
                    calendarsToExclude.append(["name":calendar["name"] as? String ?? "", "id":calendar["id"] as? String ?? ""])
                }
            }
        }
        let startTime = getStringFromDate(date: pickerStartTime.dateValue, dateFormat: "HH:mm")
        let endTime = getStringFromDate(date: pickerEndTime.dateValue, dateFormat: "HH:mm")
        

        let jsonVoiceOptions:NSDictionary = ["using": usingValue, "speakingRate": speakingRateValue, "pitch": pitchValue, "volume": volumeValue, "modulation": modulationValue]
        
        let json:NSDictionary = ["calendarsToExclude": calendarsToExclude, "eventKeywordsToIgnore": events, "barkStartTime": startTime, "barkEndTime": endTime, "voiceOptions": jsonVoiceOptions, "barkPool": arrBarkPools, "dialogWindowTextStages": arrTextStages, "intentionPrompts": arrIntentionPrompts]
        
        addLog(text: "Save events.json start")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as Data
            var jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            jsonString = jsonString.replacingOccurrences(of: "\\/", with: "/")
            print("json string = \(jsonString)")
            addLog(text: "Success: converted to string from json")
            do {
                try jsonString.write(to: jsonUrl!,
                                     atomically: true,
                                     encoding: .utf8)
                //                try jsonData.write(to: URL(fileURLWithPath: "/Users/prashant/Desktop/fmynew.json"))
                
                addLog(text: "Success: write json file:- \(jsonString)")
            } catch {
                // Handle error
                addLog(text: "Failure: write json file")
            }
            
            
        } catch _ {
            print ("JSON Failure")
            addLog(text: "Failure: convert data from json")
        }
        
        
        
    }
    
    @IBAction func btnAdvancedClicked(_ sender: Any) {
        addLog(text:"button advanced clicked")
        capturePosthog(event: "open-advanced-settings", metadata: [:])
        if advancedSettingsVcObj == nil{
            advancedSettingsVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("advancedSettingsVc")) as? advancedSettingsVc
        }
        
        self.presentAsSheet(advancedSettingsVcObj!)
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        if isCalendarListEdited{
            isCalendarListEdited = false
            capturePosthog(event: "modify-excluded-calendar-list", metadata: [:])
        }
        capturePosthog(event: "apply-settings", metadata: [:])
        addLog(text: "btnApplyClicked")
        saveSettings()
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                addLog(text: "open LateNoMore process after file save")
//                NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/LateNoMore"))
                self.launchProcess()
                let alert = NSAlert()
                alert.messageText = "Your settings have been saved."
                alert.beginSheetModal(for: self.view.window!, completionHandler: {_ in
                    addLog(text: "App terminate")
//                    NSApp.terminate(self)
                   // self.view.window?.miniaturize(self)
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.view.window?.miniaturize(self)
                        }
                    }
                })
            }
        }
        
    }
    
//    func tokenField(_ tokenField: NSTokenField, shouldAdd tokens: [Any], at index: Int) -> [Any] {
//        print(tokens)
//        return tokens
//    }
    
    
}


extension ViewController:NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return arrCalendars.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tblCellCalendars"), owner: nil) as? tblCellCalendars {

            
            cell.checkBox.title = arrCalendars[row]["name"] as? String ?? ""
            if let state = arrCalendars[row]["state"] as? Bool{
                if state{
                    cell.checkBox.state = .on
                }else{
                    cell.checkBox.state = .off
                }
            }
            
            cell.checkBox.target = self
            cell.checkBox.tag = row
            cell.checkBox.action = #selector(btncheckBoxClicked(sender:))
            return cell
        }
        
        return NSTableCellView()
    }
    
    @objc func btncheckBoxClicked(sender:NSButton){
        if arrCalendars[sender.tag]["state"] as? Bool == true{
            arrCalendars[sender.tag]["state"] = false
        }else{
            arrCalendars[sender.tag]["state"] = true
        }
        isCalendarListEdited = true
        tblViewCalendar.reloadData()
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
}

