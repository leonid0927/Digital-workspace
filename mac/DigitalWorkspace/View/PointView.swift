//
//  PointView.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/21/20.
//  Copyright © 2020 nice orca. All rights reserved.
//
import Cocoa

class PointView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.setFrameSize(NSSize(width: 5,height: 5))
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.layer?.cornerRadius = 2.5
        
        // Drawing code here.
    }
    
}
