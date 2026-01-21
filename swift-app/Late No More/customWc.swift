//
//  customWc.swift
//  Late No More
//
//  Created by Manish Jain on 18/06/25.
//

import Cocoa

class customWc: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        for i in 0..<arrAlertWcObj.count{
            let wc = arrAlertWcObj[i]
            if wc.window == self.window{
                arrAlertWcObj.remove(at: i)
                break;
            }
        }
        return true
    }
}

