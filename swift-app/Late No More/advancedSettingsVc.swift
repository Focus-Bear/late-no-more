//
//  advancedSettingsVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class advancedSettingsVc: NSViewController {

    @IBOutlet weak var btnOk: cursorButton!
    @IBOutlet weak var tabViewItemIntentionPrompts: NSTabViewItem!
    @IBOutlet weak var tabViewItemTextStages: NSTabViewItem!
    @IBOutlet weak var tabViewItemBarkPool: NSTabViewItem!
    @IBOutlet weak var tabViewItemVoiceOptions: NSTabViewItem!
    
    let voiceOptionsVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("voiceOptionsVc")) as? voiceOptionsVc
    
    let barkPoolVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("barkPoolVc")) as? barkPoolVc
    
    let textStagesVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("textStagesVc")) as? textStagesVc
    
    let intentionPromptsVcObj = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("intentionPromptsVc")) as? intentionPromptsVc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tabViewItemVoiceOptions.label = "Voice Options"
        tabViewItemBarkPool.label = "Verbal Alerts"
        tabViewItemTextStages.label = "Text Alerts"
        tabViewItemIntentionPrompts.label = "Intention Prompts"
        btnOk.title = "OK"
        
        if voiceOptionsVcObj != nil{
            tabViewItemVoiceOptions.view?.addSubview(voiceOptionsVcObj!.view)
            tabViewItemVoiceOptions.view?.addConstraints(subView: voiceOptionsVcObj!.view)
        }
        
        if barkPoolVcObj != nil{
            tabViewItemBarkPool.view?.addSubview(barkPoolVcObj!.view)
            tabViewItemBarkPool.view?.addConstraints(subView: barkPoolVcObj!.view)
        }
        
        if textStagesVcObj != nil{
            tabViewItemTextStages.view?.addSubview(textStagesVcObj!.view)
            tabViewItemTextStages.view?.addConstraints(subView: textStagesVcObj!.view)
        }
        
        if intentionPromptsVcObj != nil{
            tabViewItemIntentionPrompts.view?.addSubview(intentionPromptsVcObj!.view)
            tabViewItemIntentionPrompts.view?.addConstraints(subView: intentionPromptsVcObj!.view)
        }
    }
    override func viewWillAppear() {
        btnOk.keyEquivalent = "\r"
    }
    @IBAction func btnOkClicked(_ sender: Any) {
        addLog(text:"advance settings:- button OK clicked")
        self.dismiss(self)
    }
}
