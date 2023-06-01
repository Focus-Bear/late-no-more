//
//  intentionPromptsVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class intentionPromptsVc: NSViewController {

    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var tblView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tblView.doubleAction = #selector(tblViewDoubleClicked)
        lblTitle.stringValue = "Before you join the meeting, it's helpful to set intentions for what you want to get out of the meeting. You can change the questions here."
    }
    
    override func viewWillAppear() {
        tblView.reloadData()
    }
    @objc func tblViewDoubleClicked(){
        let selectedRow = tblView.selectedRow
        if selectedRow != -1{
            addItemVcObj?.parentVc = self
            if !(addItemVcObj?.isViewLoaded ?? false){
                addItemVcObj?.loadView()
            }
            addItemVcObj?.resetView(isAdding: false, oldItemIndex: selectedRow)
            self.presentAsSheet(addItemVcObj!)
        }
        
    }
}
extension intentionPromptsVc:NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return arrIntentionPrompts.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tblCell"), owner: nil) as? tblCell {
            cell.lblTitle.stringValue = arrIntentionPrompts[row]
            return cell
        }
        
        return NSTableCellView()
    }

}
