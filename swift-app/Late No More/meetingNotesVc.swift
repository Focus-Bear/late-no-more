//
//  meetingNotesVc.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//

import Cocoa

class meetingNotesVc: NSViewController {

    @IBOutlet var textView: customTexView!
    @IBOutlet weak var btnNoNotesRequired: Button!
    @IBOutlet weak var btnSaveNotes: Button!
    @IBOutlet var textViewNotes: customTexView!
    @IBOutlet weak var lblIntentionSaved: NSTextField!
    @IBOutlet weak var lblTitleIntention: NSTextField!
    @IBOutlet weak var lblTitle: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        btnNoNotesRequired.title = "No notes required"
        btnNoNotesRequired.buttonColor = NSColor.white.cgColor
        btnSaveNotes.title = "Save notes"
    }
    
    func resetData(intention:String, eventName:String){
        lblTitle.stringValue = eventName + ":" + "Meeting Notes"
        lblIntentionSaved.stringValue = intention
        textView.string = ""
    }
    
    @IBAction func btnNoNotesRequiredClicked(_ sender: Any) {
        self.view.window?.close()
    }
    
    @IBAction func btnSaveNotesClicked(_ sender: Any) {
        self.view.window?.close()
    }
}
