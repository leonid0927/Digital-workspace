//
//  taskCeationSubView.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/28/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa

class taskCeationSubView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    override func mouseDown(with event: NSEvent) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.createView?.DueDatePicker.isHidden = true
    }
}
