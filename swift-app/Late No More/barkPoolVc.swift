//
//  barkPoolVc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 24/04/23.
//

import Cocoa

class barkPoolVc: NSViewController {

    @IBOutlet weak var lblTitle: NSTextField!
    @IBOutlet weak var btnRemove: NSButton!
    @IBOutlet weak var btnAdd: NSButton!
    @IBOutlet weak var tblView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tblView.doubleAction = #selector(tblViewDoubleClicked)
        lblTitle.stringValue = "If you're running late for a meeting, Late No More will do verbal alerts in case you're in another room or are in hyperfocus. You can also put in Spotify URLs or Youtube URLs and the app will play them."
    }
    override func viewWillAppear() {
        tblView.reloadData()
    }
    @IBAction func btnAddClicked(_ sender: Any) {
        addItemVcObj?.parentVc = self
        if !(addItemVcObj?.isViewLoaded ?? false){
            addItemVcObj?.loadView()
        }
        addItemVcObj?.resetView(isAdding: true, oldItemIndex: -1)
        self.presentAsSheet(addItemVcObj!)
    }
    @IBAction func btnRemoveClicked(_ sender: Any) {
        if tblView.selectedRow != -1{
            var selectedRow = tblView.selectedRow
            arrBarkPools.remove(at: tblView.selectedRow)
            tblView.removeRows(at: IndexSet(integer: tblView.selectedRow))
            if selectedRow != 0{
                selectedRow = selectedRow - 1
            }
            tblView.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
        }
        if arrBarkPools.count <= 1{
            btnRemove.isEnabled = false
        }
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
extension barkPoolVc:NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if arrBarkPools.count <= 1{
            btnRemove.isEnabled = false
        }else{
            btnRemove.isEnabled = true
        }
        return arrBarkPools.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tblCell"), owner: nil) as? tblCell {
            cell.lblTitle.stringValue = arrBarkPools[row]
            return cell
        }
        
        return NSTableCellView()
    }
    

    func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
}
