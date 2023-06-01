//
//  voiceOptionsVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class voiceOptionsVc: NSViewController {

    @IBOutlet weak var btnTestSound: NSButton!
    @IBOutlet weak var sliderModulation: NSSlider!
    @IBOutlet weak var sliderVolume: NSSlider!
    @IBOutlet weak var sliderPitch: NSSlider!
    @IBOutlet weak var sliderSpeakingRate: NSSlider!
    @IBOutlet weak var popUpBtn: NSPopUpButton!

    //@IBOutlet weak var btnOk: NSButton!
    @IBOutlet weak var lblTitleModulation: NSTextField!
    @IBOutlet weak var lblTitleVaolume: NSTextField!
    @IBOutlet weak var lblTitlePitch: NSTextField!
    @IBOutlet weak var lblTitleSpekingValue: NSTextField!
    @IBOutlet weak var lblTitleUsing: NSTextField!
    
    
    @IBOutlet weak var lblValueSpeakingRate: NSTextField!
    
    @IBOutlet weak var lblValuePitch: NSTextField!
    @IBOutlet weak var lblValueVolume: NSTextField!
    @IBOutlet weak var lblValueModulation: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        lblTitleUsing.stringValue = "Using:"
        lblTitleSpekingValue.stringValue = "Speaking Rate:"
        lblTitlePitch.stringValue = "Pitch:"
        lblTitleVaolume.stringValue = "Volume:"
        lblTitleModulation.stringValue = "Modulation:"
        btnTestSound.title = "Test Voice"
        //btnOk.title = "OK"
        popUpBtn.removeAllItems()
        popUpBtn.addItems(withTitles: arrVoiceNames)
    }
 
    
    override func viewWillAppear() {
        

        if !usingValue.isEmpty{
            popUpBtn.selectItem(withTitle: usingValue)
        }
        sliderSpeakingRate.integerValue = speakingRateValue
        lblValueSpeakingRate.integerValue = speakingRateValue
        
        sliderVolume.integerValue = pitchValue
        lblValuePitch.integerValue = pitchValue
        
        sliderVolume.floatValue = volumeValue
        lblValueVolume.stringValue = "\(Float(round(100 * volumeValue) / 100))"
        
        sliderModulation.integerValue = modulationValue
        lblValueModulation.integerValue = modulationValue
    }
    
    @IBAction func popupBtnClicked(_ sender: Any) {
        usingValue = arrVoiceNames[popUpBtn.indexOfSelectedItem]
    }
    
    @IBAction func sliderSpeakingRateClicked(_ sender: Any) {
        speakingRateValue = sliderSpeakingRate.integerValue
        lblValueSpeakingRate.integerValue = speakingRateValue
    }
    
    @IBAction func sliderPitchClicked(_ sender: Any) {
        pitchValue = sliderPitch.integerValue
        lblValuePitch.integerValue = pitchValue
    }
    
    @IBAction func sliderVolumeClicked(_ sender: Any) {
        volumeValue = round(100 * sliderVolume.floatValue) / 100
        lblValueVolume.stringValue = "\(volumeValue)"
    }
    @IBAction func sliderModulationClicked(_ sender: Any) {
        modulationValue = sliderModulation.integerValue
        lblValueModulation.integerValue = modulationValue
    }
    
    @IBAction func btnTestSoundClicked(_ sender: Any) {
        let task = Process()
//        let pipe = Pipe()
        
//        task.standardOutput = pipe
//        task.standardError = pipe
        task.arguments = ["-c", "say \"I'll make sure you're never late for a meeting\" -v \"\(popUpBtn.titleOfSelectedItem ?? "")\""]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)!
    }
    
}
