//
//  addItemVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class addItemVc: NSViewController {


    @IBOutlet weak var btnAdd: NSButton!
    @IBOutlet weak var btnCancel: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var popUpBtn: NSPopUpButton!
    @IBOutlet weak var lblTitle: NSTextField!
    
    var parentVc:NSViewController?
    var oldItemIndex = 0
    var isAdding = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        popUpBtn.removeAllItems()
        popUpBtn.addItems(withTitles: ["Verbal announcement", "Spotify URL", "Youtube URL"])
        textField.delegate = self
        btnCancel.title = "Cancel"
        btnAdd.title = "Add"
    }
    override func viewWillAppear() {
        //popUpBtn.isHidden = true
    }
    func resetView(isAdding:Bool, oldItemIndex:Int){
        textField.stringValue = ""
        btnAdd.isEnabled = false
        self.isAdding = isAdding
        self.oldItemIndex = oldItemIndex
        if isAdding{
            popUpBtn.isHidden = false
            lblTitle.stringValue = "Add Verbal Alert"
            btnAdd.title = "Add"
        }else{
            lblTitle.stringValue = "Edit"
            popUpBtn.isHidden = true
            if parentVc is barkPoolVc{
                textField.stringValue = arrBarkPools[oldItemIndex]
            }else if parentVc is textStagesVc{
                textField.stringValue = arrTextStages[oldItemIndex]
            }else if parentVc is intentionPromptsVc{
                textField.stringValue = arrIntentionPrompts[oldItemIndex]
            }
            
            btnAdd.title = "Save"
            btnAdd.isEnabled = true
        }
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        if isAdding{
            if let barkPoolVcObj = parentVc as? barkPoolVc{
                arrBarkPools.append(textField.stringValue)
                barkPoolVcObj.tblView.reloadData()
                barkPoolVcObj.tblView.scrollRowToVisible(barkPoolVcObj.tblView.numberOfRows - 1)
                barkPoolVcObj.tblView.selectRowIndexes(IndexSet(integer: barkPoolVcObj.tblView.numberOfRows - 1), byExtendingSelection: false)
            }
        }else{
            if let barkPoolVcObj = parentVc as? barkPoolVc{
                arrBarkPools[oldItemIndex] = textField.stringValue
                barkPoolVcObj.tblView.reloadData()
                barkPoolVcObj.tblView.scrollRowToVisible(oldItemIndex)
            }else if let textStagesVcObj = parentVc as? textStagesVc{
                arrTextStages[oldItemIndex] = textField.stringValue
                textStagesVcObj.tblView.reloadData()
                textStagesVcObj.tblView.scrollRowToVisible(oldItemIndex)
            }else if let intentionPromptsVcObj = parentVc as? intentionPromptsVc{
                arrIntentionPrompts[oldItemIndex] = textField.stringValue
                intentionPromptsVcObj.tblView.reloadData()
                intentionPromptsVcObj.tblView.scrollRowToVisible(oldItemIndex)
            }
        }
        
        
        
        self.dismiss(self)
    }
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.dismiss(self)
    }
}
extension addItemVc: NSTextFieldDelegate{
    func controlTextDidChange(_ obj: Notification) {
        if let textfield = obj.object as? NSTextField{
            if textfield == self.textField{
                if textfield.stringValue.isEmpty{
                    btnAdd.isEnabled = false
                }else{
                    btnAdd.isEnabled = true
                }
            }
        }
    }
}
