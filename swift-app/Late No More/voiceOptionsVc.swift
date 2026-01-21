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
        for key in arrVoiceNames.keys{
            popUpBtn.addItem(withTitle: key)
        }
        
    }
 
    
    override func viewWillAppear() {
        

        if !usingValue.isEmpty{
            popUpBtn.selectItem(withTitle: usingValue)
        }
        sliderSpeakingRate.floatValue = speakingRateValue
        lblValueSpeakingRate.floatValue = speakingRateValue
        
        sliderVolume.floatValue = pitchValue
        lblValuePitch.floatValue = pitchValue
        
        sliderVolume.floatValue = volumeValue
        lblValueVolume.stringValue = "\(Float(round(100 * volumeValue) / 100))"
        
        sliderModulation.integerValue = modulationValue
        lblValueModulation.integerValue = modulationValue
    }
    
    @IBAction func popupBtnClicked(_ sender: Any) {
        usingValue = popUpBtn.titleOfSelectedItem ?? ""
    }
    
    @IBAction func sliderSpeakingRateClicked(_ sender: Any) {
        speakingRateValue = sliderSpeakingRate.floatValue
        lblValueSpeakingRate.floatValue = sliderSpeakingRate.floatValue
    }
    
    @IBAction func sliderPitchClicked(_ sender: Any) {
        pitchValue = sliderPitch.floatValue
        lblValuePitch.floatValue = sliderPitch.floatValue
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
        testVoice()
//        let task = Process()
//        task.arguments = ["-c", "say \"I'll make sure you're never late for a meeting\" -v \"\(popUpBtn.titleOfSelectedItem ?? "")\""]
//        task.launchPath = "/bin/zsh"
//        task.standardInput = nil
//        task.launch()
    }
    
    func testVoice(){
        addLog(text: "test Voice")
        let voice = arrVoiceNames[usingValue]
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) {
            
            textToSpeechObject.speak("I'll make sure you're never late for a meeting",
                      voice: voice,
                           rate: speakingRateValue,//0.4
                           pitch: pitchValue,//1.2
                           volume: volumeValue)//0.8
        }
    }
    

}


