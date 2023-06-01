//
//  AppDelegate.swift
//  Late No More
//
//  Created by Prashant Sawnani on 20/12/22.
//

import Cocoa
import EventKit
import Sparkle

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menuItemCheckForUpdates: NSMenuItem!
    var updater: SUUpdater?
    
    func applicationWillFinishLaunching(_ notification: Notification) {

        let bundel = Bundle.main.bundleIdentifier ?? ""
        let applicationSupportPath = "/Users/\(NSUserName())/Library/Application Support/\(bundel)"
        CreateDirectoryIfNotExist(path: applicationSupportPath)
        let applicationSupportURL  = URL(fileURLWithPath: applicationSupportPath)
        jsonUrl = applicationSupportURL.appendingPathComponent("events.json")
        DebugLogsURL = applicationSupportURL.appendingPathComponent("Late No More_Logs.txt")
        helperAppUrl = applicationSupportURL.appendingPathComponent("LateNoMore")
        if let version = Bundle.main.releaseVersionNumber,let build = Bundle.main.buildVersionNumber{
            addLog(text: "running app version:" + " " + version + "." + build)
            appVersion = version + "." + build
        }
        if let path = Bundle.main.path(forResource: "LateNoMore", ofType: "") {
            let url = URL(fileURLWithPath: path)
            print(url)
            if FileManager.default.fileExists(atPath: helperAppUrl!.path){
                do{
                    try FileManager.default.removeItem(at: helperAppUrl!)
                }catch{
                    print(error)
                }
            }
            
            do{
                try FileManager.default.copyItem(at: url, to: helperAppUrl!)
            }catch{
                print(error)
            }
            
            
        }
        
        let systemVersion = ProcessInfo().operatingSystemVersion
        addLog(text: "macOS Version \(systemVersion.majorVersion).\(systemVersion.minorVersion).\(systemVersion.patchVersion)")
        macOSVersion = "\(systemVersion.majorVersion).\(systemVersion.minorVersion).\(systemVersion.patchVersion)"
        
        let iconUrl = applicationSupportURL.appendingPathComponent("icon.png")
        if !FileManager.default.fileExists(atPath: iconUrl.path){
            if let path = Bundle.main.path(forResource: "icon", ofType: "png") {
                do {
                    try FileManager.default.copyItem(atPath: path, toPath: iconUrl.path)
                }catch{
                    print(error)
                }
            
            }
        }
        
        menuItemCheckForUpdates.title = "Check for updates"
        updater = SUUpdater(for: Bundle.main)
        updater?.automaticallyChecksForUpdates = true

        if UserDefaults.standard.object(forKey: kUserdefaultsFirstRun) == nil{
            showOnboardingWindow()
        }else{
            self.updater?.checkForUpdatesInBackground()
            loadFullApp()
        }
    }
    
    func loadFullApp(){
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
            
        case .authorized:
            print("Authorized")
            addLog(text: "Authorized")
            showMainWindow()
        case .denied:
            print("Access denied")
            addLog(text: "Access denied")
            let alert = NSAlert()
            alert.messageText = "You don't have permission to access calendar, Please allow access to calendars in Preferences and Click Ok"
            alert.runModal()
            quitAndRestartApp()
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                                        {(granted: Bool, error: Error?) -> Void in
                if granted {
                    print("Access granted")
                    addLog(text: "Access granted")
                    DispatchQueue.main.async {
                        showMainWindow()
                    }
                    
                } else {
                    print("Access denied")
                    addLog(text: "Access denied")
                    DispatchQueue.main.async {
                        NSApp.terminate(self)
                    }
                }
            })
            
            print("Not Determined")
            addLog(text: "Not Determined")
        default:
            print("Case Default")
            addLog(text: "Case Default")
        }
    }
    
    func quitAndRestartApp(){
        addLog(text: "quitAndRestartApp")
        let task = Process()
        var args: [AnyHashable] = []
        args.append("-c")
        args.append("sleep \(1); open \"\(Bundle.main.bundlePath)\"")
        task.launchPath = "/bin/sh"
        task.arguments = args as? [String]
        task.launch()

        NSApp.terminate(self)
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
    }
    var isShouldTerminate = false
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        
        if isShouldTerminate{
            return .terminateNow
        }else{
            if UserDefaults.standard.object(forKey: kUserdefaultsFirstRun) != nil{// it means onboarding is not over
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        alert.messageText = "Do you want to keep Late No More notifications running?"
                        alert.addButton(withTitle: "Keep them please")
                        alert.addButton(withTitle: "Stop the notifications!")
                        let result = alert.runModal()
                        if result == .alertFirstButtonReturn{
                            
                        }else{
                            terminateProcess()
                        }
                        self.isShouldTerminate = true
                        NSApp.terminate(self)
                    }
                }
                return .terminateCancel
                
            }else{
                return .terminateNow
            }
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        
        
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
//todo jab bhi binary updat kro sign krke hi update kro 
