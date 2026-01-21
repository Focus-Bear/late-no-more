//
//  customAlertVc.swift
//  Late No More
//
//  Created by Manish Jain on 17/06/25.
//

import Cocoa

class customAlertVc: NSViewController {

    @IBOutlet weak var btnStartMeeting: Button!
    @IBOutlet weak var lblCantExtractUrl: NSTextField!
    @IBOutlet weak var lbCloseThisPopup: NSTextField!
    @IBOutlet weak var btnIDontNeedToAttend: Button!
    @IBOutlet weak var boxJoinMeetingSecond: NSBox!
    @IBOutlet weak var boxJoinMeeting: NSBox!
    
    @IBOutlet weak var boxMentallyPrepare: NSBox!
    @IBOutlet weak var boxMentallyPrepareSecond: NSBox!
    
    @IBOutlet var textViewSecond: customTexView!
    @IBOutlet var textViewFirst: customTexView!
    @IBOutlet weak var lblQuestionSecond: NSTextField!
    @IBOutlet weak var lblQuestionFirst: NSTextField!
    @IBOutlet weak var btnJoinNow: Button!
    @IBOutlet weak var btnLink: underLineButton!
    @IBOutlet weak var lblEventName: NSTextField!
    @IBOutlet weak var lblDateTime: NSTextField!
    @IBOutlet weak var lblTitle: NSTextField!
    
    var linkUrl:URL?
    var nagShowTime:Date?
    var timerCheckMeeting:Timer?
    var joinMeetingClicked = false
    var timerVerbalAlerts:Timer?
    var parseInfo: MeetingLinkInfo?
    var eventId:String = ""
    var remainingSeconds = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        lblTitle.stringValue = "Your Meeting Starts in 2 Minutes"
        lblDateTime.stringValue = "Today, 16th September 2020, 11:26"
        lblEventName.stringValue = "Meeting with new investors"
        btnJoinNow.title = "Join Now"
        lblQuestionFirst.stringValue = "🧠 What do you want to achieve in this meeting?"
        lblQuestionSecond.stringValue = "⭐️ How do you want to show up for the meeting?"
        
        btnIDontNeedToAttend.title = "I don't need to attend "
        textViewFirst.placeHolderTitleString = NSAttributedString(string: "What do you want to achieve in this meeting?", attributes: [NSAttributedString.Key.foregroundColor : NSColor.secondaryLabelColor, NSAttributedString.Key.font : NSFont.systemFont(ofSize: textViewFirst.font?.pointSize ?? 22)])
        
        textViewSecond.placeHolderTitleString = NSAttributedString(string: "How do you want to show up for this meeting?", attributes: [NSAttributedString.Key.foregroundColor : NSColor.secondaryLabelColor, NSAttributedString.Key.font : NSFont.systemFont(ofSize: textViewSecond.font?.pointSize ?? 22)])
        textViewFirst.delegate = self
        textViewSecond.delegate = self
        btnIDontNeedToAttend.buttonColor = NSColor.white.cgColor
        lblTitle.font = NSFont.monospacedSystemFont(ofSize: 16, weight: .semibold)
    }
    
    func resetData(title:String,time:Date, url:URL?, notes:String, eventId:String){
        parseInfo = nil
        lbCloseThisPopup.isHidden = true
        joinMeetingClicked = false
        boxMentallyPrepareSecond.isHidden = true
        boxJoinMeetingSecond.isHidden = true
        textViewFirst.string = ""
        textViewSecond.string = ""
        btnStartMeeting.isHidden = false
        btnIDontNeedToAttend.isHidden = false
        btnJoinNow.isHidden = false
        
        nagShowTime = Date()
        linkUrl = nil
        self.eventId = eventId
        
        
        if let url = url{
            linkUrl = url
            btnLink.title = url.absoluteString
        }else{
            let parseInfo = parseMeetingNotes(notes)
            self.parseInfo = parseInfo
            if let meetUrl = parseInfo.meetURL{
                if let url = URL(string: meetUrl) {
                    linkUrl = url
                    btnLink.title = url.absoluteString
                }
            }
        }
       // https://teams.live.com/dl/launcher/launcher.html?url=%2F_%23%2Fmeet%2F9366626883802%3Fp%3Dy8AV3Pv7YejD2P3uSy%253E%26anon%3Dtrue&type=meet&deeplinkId=043901a0-f26c-4e58-946a-3c07b85b3c9d&directDl=true&msLaunch=true&enableMobilePage=true&suppressPrompt=true
        if linkUrl == nil{
            btnJoinNow.isEnabled = false
            btnLink.isHidden = true
            lblCantExtractUrl.isHidden = false
        }else{
            btnJoinNow.isEnabled = true
            btnLink.isHidden = false
            lblCantExtractUrl.isHidden = true
        }
        lblEventName.stringValue = title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy, h:mm a"

        let date = time // your date object
        let dateString = "Today, " + dateFormatter.string(from: date)
        lblDateTime.stringValue = dateString
        
        timerCheckMeeting?.invalidate()
        timerCheckMeeting = nil
        DispatchQueue.global().sync {
            self.timerCheckMeeting?.invalidate()
            self.timerCheckMeeting = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkIsMeetingStarted), userInfo: nil, repeats: true)
            RunLoop.main.add((self.timerCheckMeeting!), forMode: RunLoop.Mode.common)
        }
        
        timerVerbalAlerts?.invalidate()
        timerVerbalAlerts = nil
        lblTitle.stringValue = "Your Meeting Starts in 2 Minutes"
        updateCountdown()
    }
    
    @objc func checkIsMeetingStarted(){
        if let settingsDictionary = NSDictionary(contentsOfFile: settingForScreeenTimeFileURL!.path){
            if let isUserOnMeeting = settingsDictionary.value(forKey: "isUserOnMeeting") as? Bool, let meetingStartTime = settingsDictionary.value(forKey: "meetingStartTime") as? String{
                if isUserOnMeeting{
                    if let meetingStartTimeObject = getDateFromString(date: meetingStartTime, dateFormat: "yyyy-MM-dd HH-mm-ss"){
                        let nagShowTime = nagShowTime ?? Date()
                        if meetingStartTimeObject.compare(nagShowTime) == .orderedDescending{
                            meetingDetectedByFocusBear()
                        }
                    }
                }
            }
        }
        remainingSeconds -= 1
        updateCountdown()
    }
    
    func updateCountdown() {
        let absSeconds = abs(remainingSeconds)
        let minutes = absSeconds / 60
        let seconds = absSeconds % 60
        var minutesText = "Minutes"
        
        if minutes == 0{
            if seconds == 1{
                minutesText = "Second"
            }else{
                minutesText = "Seconds"
            }
        }else if minutes == 1{
            minutesText = "Minutes"
        }
        
        
        if remainingSeconds >= 0 {
            lblTitle.textColor = .labelColor
            lblTitle.stringValue = String(format: "Your Meeting Starts in %d:%02d \(minutesText)", minutes, seconds)
        } else {
            lblTitle.stringValue = String(format: "Your Meeting Starts in -%d:%02d \(minutesText)", minutes, seconds)
            lblTitle.textColor = .systemRed
        }
    }
    
    func meetingTimeShowVerbalAlerts(){
        if !joinMeetingClicked{
            timerVerbalAlerts?.invalidate()
            timerVerbalAlerts = nil
            DispatchQueue.global().sync {
                self.timerVerbalAlerts?.invalidate()
                self.timerVerbalAlerts = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.playVerbalAlert), userInfo: nil, repeats: true)
                RunLoop.main.add((self.timerVerbalAlerts!), forMode: RunLoop.Mode.common)
            }
        }
    }
    
    @objc func playVerbalAlert(){
        let voice = arrVoiceNames[usingValue]
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) {
            
            textToSpeechObject.speak(arrBarkPools.randomElement() ?? "",
                      voice: voice,
                           rate: speakingRateValue,//0.4
                           pitch: pitchValue,//1.2
                           volume: volumeValue)//0.8
        }
    }
    
    func meetingDetectedByFocusBear(){
        boxJoinMeetingSecond.isHidden = false
        btnStartMeeting.isHidden = true
        btnIDontNeedToAttend.isHidden = true
        btnJoinNow.isHidden = true
    }
    
    override func viewWillDisappear() {
        timerCheckMeeting?.invalidate()
        timerCheckMeeting = nil
        timerVerbalAlerts?.invalidate()
        timerVerbalAlerts = nil
        btnStartMeeting.isHidden = false
        btnIDontNeedToAttend.isHidden = false
        btnJoinNow.isHidden = false
    }
    
    @IBAction func btnLinkClicked(_ sender: Any) {
        if let url = linkUrl{
            NSWorkspace.shared.open(url)
        }
        joinMeetingClicked = true
        timerVerbalAlerts?.invalidate()
        timerVerbalAlerts = nil
    }
    
    @IBAction func btnAttendClicked(_ sender: Any) {
        if !joinMeetingClicked{
            btnLinkClicked(self)
        }
        lbCloseThisPopup.isHidden = false
    }
    

    
    @IBAction func btnIDontNeedToAttendClicked(_ sender: Any) {
        for i in 0..<arrAlertWcObj.count{
            let wc = arrAlertWcObj[i]
            if wc.window == self.view.window{
                arrAlertWcObj.remove(at: i)
                break;
            }
        }
        self.view.window?.close()
    }
}

extension customAlertVc:NSTextViewDelegate{
    func textDidChange(_ notification: Notification) {
        if let textView = notification.object as? NSTextView{
            if textView == textViewFirst || textView == textViewSecond{
                if textViewFirst.string.isEmpty && textViewSecond.string.isEmpty{
                    boxMentallyPrepareSecond.isHidden = true
                }else{
                    boxMentallyPrepareSecond.isHidden = false
                }
            }
        }
    }
}
struct MeetingLinkInfo {
    var meetURL: String?
    var phoneNumber: String?
    var phonePIN: String?
    var moreNumbersURL: String?
    var supportURL: String?
}

func parseMeetingNotes(_ notes: String) -> MeetingLinkInfo {
    var info = MeetingLinkInfo()
   
    // Google Meet link
    if let match = notes.range(of: #"https://meet\.google\.com/[a-z0-9\-]+"#, options: .regularExpression) {
        info.meetURL = String(notes[match])
        
        // Phone number
        if let match = notes.range(of: #"\+1\s[\d\-]+"#, options: .regularExpression) {
            info.phoneNumber = String(notes[match])
        }

        // Phone PIN
        if let match = notes.range(of: #"PIN:\s?\d+#"#, options: .regularExpression) {
            info.phonePIN = String(notes[match])
        }
        
//        https://teams.live.com/meet/9387222203093?p=9IrX5g5YpOQHxLPN7m
        // More phone numbers link
        if let match = notes.range(of: #"https://tel\.meet/[^\s]+"#, options: .regularExpression) {
            info.moreNumbersURL = String(notes[match])
        }

        // Learn more about Meet support link
        if let match = notes.range(of: #"https://support\.google\.com/[^\s]+"#, options: .regularExpression) {
            info.supportURL = String(notes[match])
        }
    }else if let match = notes.range(of: #"https://[\w\.]*zoom\.us/j/\d+[^\s]*"#, options: .regularExpression) {//"Zoom
        info.meetURL = String(notes[match])
    }else if let match = notes.range(of: #"https://teams\.(microsoft\.com|live\.com)/[^\s>)]+"#, options: .regularExpression) {
        info.meetURL = String(notes[match]) // Will match both domains
    }else if let match = notes.range(of: #"https://[a-zA-Z0-9\-]+\.webex\.com/[^ \n]+"#, options: .regularExpression) {//"Webex
        info.meetURL = String(notes[match])
    }else if let match = notes.range(of: #"https://meet\.jit\.si/[a-zA-Z0-9\-]+"#, options: .regularExpression) {//"Jitsi
        info.meetURL = String(notes[match])
    }else if let match = notes.range(of: #"https://join\.skype\.com/[a-zA-Z0-9]+"#, options: .regularExpression) {//"Skype
        info.meetURL = String(notes[match])
    }
    return info
}
