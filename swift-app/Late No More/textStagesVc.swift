//
//  textStagesVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class textStagesVc: NSViewController {
    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var tblView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tblView.doubleAction = #selector(tblViewDoubleClicked)
        lblTitle.stringValue = "Late No More will show popups 2 minutes before the meeting. The messages increase in urgency as it gets closer to the start time. Feel free to tweak the messages."
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
extension textStagesVc:NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return arrTextStages.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tblCell"), owner: nil) as? tblCell {
            cell.lblTitle.stringValue = arrTextStages[row]
            return cell
        }
        
        return NSTableCellView()
    }

}
