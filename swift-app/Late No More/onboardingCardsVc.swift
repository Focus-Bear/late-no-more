//
//  onboardingCardsVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 03/05/23.
//

import Cocoa

class onboardingCardsVc: NSViewController {

    @IBOutlet weak var btnVisitUrl: underLineButton!
    @IBOutlet weak var lblSubTitle: NSTextField!
    @IBOutlet weak var boxFourth: NSBox!
    @IBOutlet weak var boxThird: NSBox!
    @IBOutlet weak var boxSecond: NSBox!
    @IBOutlet weak var boxFirst: NSBox!
    @IBOutlet weak var btnBack: NSButton!
    @IBOutlet weak var btnNext: NSButton!
    @IBOutlet weak var imgView: NSImageView!
    @IBOutlet weak var lblTitle: NSTextField!
    var currentSlideIndex = 0
    var arrCurrentDic = [["title":"Welcome to Late No More", "subTitle":"You'll now get reminders 2 minutes before your meetings start.", "image":#imageLiteral(resourceName: "reminders_Image")],
                         ["title":"Set Intentions", "subTitle":"You can now set intention for your meeting after it starts.", "image":#imageLiteral(resourceName: "set_Intention_Image")],
                         ["title":"Connect your calendar accounts", "subTitle":"You need to connect your calendar accounts to MacOS Calendar for Late No More to work.", "image":#imageLiteral(resourceName: "cal")],
                         ["title":"Block distractions", "subTitle":"If you'd like help blocking distractions, check out focusbear.io as well 🙂.", "image":#imageLiteral(resourceName: "img_BlockedPage")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        btnBack.title = "Back"
        btnVisitUrl.title = "Click here to visit focusbear.io"
//        capturePosthog(event: "onboarding-shown", metadata: [:])
    }
    override func viewWillAppear() {
        currentSlideIndex = 0
        recheckSlideState()
    }
    
    func recheckSlideState(){
        btnVisitUrl.isHidden = true
        if currentSlideIndex == 0{
            boxFirst.fillColor = NSColor.systemBlue
            boxSecond.fillColor = NSColor.quaternaryLabelColor
            boxThird.fillColor = NSColor.quaternaryLabelColor
            boxFourth.fillColor = NSColor.quaternaryLabelColor

            btnBack.isHidden = true
            btnNext.title = "Next"
        }else if currentSlideIndex == 1{
            boxFirst.fillColor = NSColor.quaternaryLabelColor
            boxSecond.fillColor = NSColor.systemBlue
            boxThird.fillColor = NSColor.quaternaryLabelColor
            boxFourth.fillColor = NSColor.quaternaryLabelColor
            
            btnBack.isHidden = false
            btnNext.title = "Next"
        }else if currentSlideIndex == 2{
            boxFirst.fillColor = NSColor.quaternaryLabelColor
            boxSecond.fillColor = NSColor.quaternaryLabelColor
            boxThird.fillColor = NSColor.systemBlue
            boxFourth.fillColor = NSColor.quaternaryLabelColor
            
            btnBack.isHidden = false
            btnNext.title = "Next"
        }else if currentSlideIndex == 3{
            boxFirst.fillColor = NSColor.quaternaryLabelColor
            boxSecond.fillColor = NSColor.quaternaryLabelColor
            boxThird.fillColor = NSColor.quaternaryLabelColor
            boxFourth.fillColor = NSColor.systemBlue
            
            btnVisitUrl.isHidden = false
            btnBack.isHidden = false
            btnNext.title = "Onwards"
            
            
        }

        lblTitle.stringValue = arrCurrentDic[currentSlideIndex]["title"] as? String ?? ""
        lblSubTitle.stringValue = arrCurrentDic[currentSlideIndex]["subTitle"] as? String ?? ""
        imgView.image = arrCurrentDic[currentSlideIndex]["image"] as? NSImage
        
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        addLog(text:"onboardingCardsVc:- btn Back Clicked")
        currentSlideIndex -= 1
        recheckSlideState()
    }
    @IBAction func btnNextClicked(_ sender: Any) {
        if currentSlideIndex == arrCurrentDic.count - 1{
            self.view.window?.styleMask.insert(.closable)
            UserDefaults.standard.set(true, forKey: kUserdefaultsFirstRun)
            self.view.window?.close()
            appdelegate?.loadFullApp()
        }else{
            addLog(text:"onboardingCardsVc:- btn Next Clicked")
            currentSlideIndex += 1
            recheckSlideState()
        }
    }
    @IBAction func btnVisitUrlClicked(_ sender: Any) {
        if let url = URL(string: "https://www.focusbear.io"){
            NSWorkspace.shared.open(url)
        }
    }
}
