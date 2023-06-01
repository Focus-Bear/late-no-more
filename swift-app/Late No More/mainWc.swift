//
//  mainWc.swift
//  Late No More
//
//  Created by Prashant Sawnani on 20/12/22.
//

import Cocoa

class mainWc: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        //NSApp.terminate(self)
        return true
    }
}
