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
        addFocusBearTabIfInstalled()
    }

    /// The Focus Bear tab, only once a Focus Bear that can open meeting links is installed.
    private func addFocusBearTabIfInstalled() {
        guard FocusBearInstallation.canOpenBrowserLinks, let tabView = tabViewItemVoiceOptions.tabView else { return }
        let item = NSTabViewItem(identifier: Self.focusBearTabIdentifier)
        item.label = Self.focusBearTabLabel
        item.view = makeFocusBearSettingsView()
        tabView.addTabViewItem(item)
    }

    private func makeFocusBearSettingsView() -> NSView {
        let checkBox = NSButton(checkboxWithTitle: OpenMeetingsInFocusBearSetting.title, target: self,
                                action: #selector(openMeetingsInFocusBearClicked(_:)))
        checkBox.state = OpenMeetingsInFocusBearSetting.isOn ? .on : .off
        let explanation = NSTextField(wrappingLabelWithString: OpenMeetingsInFocusBearSetting.explanation)
        explanation.textColor = .secondaryLabelColor
        let stack = NSStackView(views: [checkBox, explanation])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = Self.focusBearTabSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        let container = NSView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: Self.focusBearTabMargin),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Self.focusBearTabMargin),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Self.focusBearTabMargin),
            // The explanation wraps at the tab's width instead of running off it on one line.
            explanation.widthAnchor.constraint(equalTo: stack.widthAnchor),
        ])
        return container
    }

    @objc private func openMeetingsInFocusBearClicked(_ sender: NSButton) {
        OpenMeetingsInFocusBearSetting.isOn = sender.state == .on
        addLog(text: "advance settings:- open meetings in Focus Bear's browser \(OpenMeetingsInFocusBearSetting.isOn)")
    }

    private static let focusBearTabIdentifier = "focusBear"
    private static let focusBearTabLabel = "Focus Bear"
    private static let focusBearTabMargin: CGFloat = 20
    private static let focusBearTabSpacing: CGFloat = 8
    override func viewWillAppear() {
        btnOk.keyEquivalent = "\r"
    }
    @IBAction func btnOkClicked(_ sender: Any) {
        addLog(text:"advance settings:- button OK clicked")
        self.dismiss(self)
    }
}
