//
//  warnUserVc.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//

import Cocoa

class warnUserVc: NSViewController {

    @IBOutlet weak var btnGotIt: Button!
    @IBOutlet weak var lblSubTitle: NSTextField!
    @IBOutlet weak var lblTitle: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        lblTitle.stringValue = "Late No More: (evt.summary) ((evt.calendarName)) is starting in 15 minutes."
        lblSubTitle.stringValue = "I'll remind you again (DialogConfig.LOOK_AHEAD_MINUTES) minutes before."
        btnGotIt.title = "Got it"
    }
    
    func resetData(title:String, calendarName:String){
        lblTitle.stringValue = "Late No More: \(title) (\(calendarName)) is starting in 15 minutes."
        lblSubTitle.stringValue = "I'll remind you again 2 minutes before."
    }
    
    @IBAction func btnGotItClicked(_ sender: Any) {
        self.view.window?.close()
    }
}
