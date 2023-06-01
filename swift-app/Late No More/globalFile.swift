//
//  globalFile.swift
//  Late No More
//
//  Created by Prashant Sawnani on 20/12/22.
//

import Cocoa

let kUserdefaultsFirstRun = "firstrun"
let appdelegate = NSApplication.shared.delegate as? AppDelegate
var helperAppUrl:URL!
let mainStoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
let mainWcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("mainWc")) as? mainWc
let mainVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ViewController")) as? ViewController
let addItemVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("addItemVc")) as? addItemVc

var onboardingCardsVcObj:onboardingCardsVc?
func getonboardingCardsVcObject()-> onboardingCardsVc{
    if onboardingCardsVcObj == nil{
        onboardingCardsVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("onboardingCardsVc")) as? onboardingCardsVc
    }
    return onboardingCardsVcObj!
}


func showMainWindow(){
    mainWcObj?.contentViewController = mainVcObj
    mainWcObj?.showWindow(mainVcObj)
    addLog(text:"showMainWindow")
}

func showOnboardingWindow(){
    mainWcObj?.contentViewController = getonboardingCardsVcObject()
    mainWcObj?.window?.styleMask.remove(.closable)
    mainWcObj?.showWindow(getonboardingCardsVcObject())
    addLog(text:"showOnboardingWindow")
}

var jsonUrl: URL?
//******************************************CreateDirectoryIfNotExist*******************************************************//
func CreateDirectoryIfNotExist(path:String){
    addLog(text: "func:- CreateDirectoryIfNotExist: \(path)")
    if !FileManager.default.fileExists(atPath: path){
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            addLog(text: "func:- CreateDirectoryIfNotExist Done")
        }catch{
            addLog(text: "func:- CreateDirectoryIfNotExist Failed")
        }
    }else{
        addLog(text: "func:- CreateDirectoryIfNotExist exist already")
    }
}

class cursorButton: NSButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil))
    }
    
    override func mouseEntered(with event: NSEvent) {
        NSCursor.pointingHand.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        NSCursor.arrow.set()
    }
}


func getDateFromString(date:String, dateFormat:String)->Date?{
    let string = date
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    return dateFormatter.date(from: string)
}

func getStringFromDate(date:Date, dateFormat:String)->String{
    let df = DateFormatter()
    df.dateFormat = dateFormat
    let now = df.string(from: date)
    return now
}



var DebugLogsURL:URL!

class Log: TextOutputStream {
    
    func write(_ string: String) {
        //        let fm = FileManager.default
        
        if let log = DebugLogsURL{//fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Debug_Logs.txt")
            if let handle = try? FileHandle(forWritingTo: log) {
                handle.seekToEndOfFile()
                handle.write(string.data(using: .utf8)!)
                handle.closeFile()
            } else {
                try? string.data(using: .utf8)?.write(to: log)
            }
        }
    }
    static var log: Log = Log()
    private init() {} // we are sure, nobody else could create it
}

func addLog(text:String){
    // if isDebugModeEnabled{
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let now = df.string(from: Date())
    
    print(now , " - ", text, to: &Log.log)
    //}
}



var usingValue = ""
var speakingRateValue = 0
var pitchValue = 0
var volumeValue:Float = 0.0
var modulationValue = 0

var arrVoiceNames = [String]()

extension NSView{
    func addConstraints(subView:NSView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        //Trailing
        let trailing = NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        //Leading
        let leading = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        //Bottom
        let bottom = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        //Height to be fixed for SubView same as AdHeight
        let height = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        self.addConstraint(trailing)
        self.addConstraint(bottom)
        self.addConstraint(leading)
        //Add height constraint to the subview, as subview owns it.
        self.addConstraint(height)
    }
}


var arrBarkPools = ["yellow alert, meeting imminent",
                    "red alert",
                    "heyyoo... it's time",
                    "beep beep!",
                    "meeting time!",
                    "hey!!",
                    "check your calendar!"]

var arrTextStages = ["😊 heads up, meeting starting soon!",
                     "😅 fyi your meeting will begin in a moment",
                     "😥 all aboard! meeting about to depart",
                     "😰 final call!",
                     "😱 you are late."]


var arrIntentionPrompts = ["what do you want to contribute to the meeting?",
                           "what will you learn?",
                           "why is it important to pay attention in this meeting?"]


func terminateProcess(){
    addLog(text: "func:- terminateProcess")
    capturePosthog(event: "stop-late-no-more-binary", metadata: [:])
    let pipe = Pipe()

    let task = Process()
    task.launchPath = "/usr/bin/killall"
    task.arguments = ["LateNoMore"]
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8) {
        print(output)
    }
//        sleep(1)
//        let runningApps = NSWorkspace.shared.runningApplications
//        for app in runningApps{
//
//            print(app.localizedName?.lowercased())
//            if app.localizedName?.lowercased() == "terminal"{
//                app.terminate()
//                break;
//            }
//        }
    addLog(text: "terminateProcess done")
}


class underLineButton: cursorButton {
    
    var titleColor = NSColor.labelColor
    func setDisable(title:String){
        isEnabled = false
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = self.alignment
        paragraph.lineBreakMode = .byTruncatingTail
        let attrs = [NSAttributedString.Key.foregroundColor: NSColor.secondaryLabelColor, NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        let attrString: NSAttributedString = NSAttributedString(string: title, attributes: attrs)
        self.attributedTitle = attrString
    }
    
    func setEnable(title:String){
        isEnabled = true
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = self.alignment
        paragraph.lineBreakMode = .byTruncatingTail
        let attrs = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        let attrString: NSAttributedString = NSAttributedString(string: title, attributes: attrs)
        self.attributedTitle = attrString
    }
    
    override var title: String {
        didSet {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = self.alignment
            paragraph.lineBreakMode = .byTruncatingTail
            let attrs = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            let attrString: NSAttributedString = NSAttributedString(string: title, attributes: attrs)
            self.attributedTitle = attrString
        }
    }
}


var macAddress = GetMACAddressString()
var appVersion = ""
var macOSVersion = ""
func GetMACAddressString() -> String {
   if let intfIterator = FindEthernetInterfaces() {
       if let macAddress = GetMACAddress(intfIterator) {
           let macAddressAsString = macAddress.map( { String(format:"%02x", $0) } )
               .joined(separator: ":")
           return macAddressAsString
       }
       IOObjectRelease(intfIterator)
   }
   return ""
}
func FindEthernetInterfaces() -> io_iterator_t? {
   
   let matchingDict = IOServiceMatching("IOEthernetInterface") as NSMutableDictionary
   matchingDict["IOPropertyMatch"] = [ "IOPrimaryInterface" : true]
   
   var matchingServices : io_iterator_t = 0
   if IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &matchingServices) != KERN_SUCCESS {
       return nil
   }
   
   return matchingServices
}
func GetMACAddress(_ intfIterator : io_iterator_t) -> [UInt8]? {
   
   var macAddress : [UInt8]?
   
   var intfService = IOIteratorNext(intfIterator)
   while intfService != 0 {
       
       var controllerService : io_object_t = 0
       if IORegistryEntryGetParentEntry(intfService, "IOService", &controllerService) == KERN_SUCCESS {
           
           let dataUM = IORegistryEntryCreateCFProperty(controllerService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0)
           if let data = dataUM?.takeRetainedValue() as? NSData {
               macAddress = [0, 0, 0, 0, 0, 0]
               data.getBytes(&macAddress!, length: macAddress!.count)
           }
           IOObjectRelease(controllerService)
       }
       
       IOObjectRelease(intfService)
       intfService = IOIteratorNext(intfIterator)
   }
   
   return macAddress
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

func capturePosthog(event:String, metadata:[String:Any]){
    addLog(text: "capturePosthog event: \(event)")
    
    let responsePath = "https://app.posthog.com/capture/"
    if let myUrl = NSURL(string: responsePath){
        
        //addLog(text: "api call capture \(myUrl)")
        let request = NSMutableURLRequest(url:myUrl as URL);
        request.httpMethod = "POST";
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let distinct_id = macAddress

        
        var properties = [String:Any]()
        
        properties["distinct_id"] = distinct_id
        properties["appVersion"] = appVersion
        properties["macOSVersion"] = macOSVersion
        properties["USES_MAC_APP"] = true
        for key in metadata.keys{
            properties[key] = metadata[key]
        }
        
        
        let json: [String: Any] = [
            "api_key": "phc_vb06v8qtjM1nomW5U4CLXQMs83ym4kVh6Ki4H6Diqrx",
            "event": event,
            "context": [
                "os": "MacOS",
                "osVersion": macOSVersion,
                "appVersion": appVersion
            ],
            "properties": properties
        ]

        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{ //it means it is right
                    
                 //   addLog(text: "api call capturePosthog success")
                    return;
                }else{
                    addLog(text: "api call capturePosthog error:- statusCode is \(httpResponse.statusCode)")
                    writeJsonInLog(data: data)
                    return
                }
            }
            if error != nil {
                addLog(text: "api call capturePosthog error: \(error!.localizedDescription)")
                return
            }
            
            return
        }
        
        task.resume()
    }else{
        
        return
    }
}
func writeJsonInLog(data: Data?){
    if data != nil{
        do {
            if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                addLog(text: "json is:- \(jsonResult)")
            }
        }catch{
            
        }
    }
}
