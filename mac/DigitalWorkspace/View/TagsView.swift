//
//  TagsView.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/21/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa

class TagsView: NSView {
    var taglist: [String]!
    var parentScrollView: NSScrollView!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    public func setScrollView(scrollView: NSScrollView){
        parentScrollView = scrollView
    }
    public func refresh(tags: [String]){
        self.setBoundsOrigin(NSPoint(x: 0, y: 0))
        self.taglist = tags
        for v in self.subviews{
            v.removeFromSuperview();
        }
        var index = 0
        for tag in tags {
            let tagview = NSTextField(frame: NSMakeRect(5+CGFloat(65 * index),2,60,14))
            index += 1
            tagview.isEditable = false
            tagview.isSelectable = false
            tagview.drawsBackground = false
            tagview.isBezeled = false
            tagview.alignment = .center
            
            tagview.lineBreakMode = .byClipping
            tagview.cell?.wraps = false
            tagview.font = NSFont.systemFont(ofSize: 10)
            tagview.stringValue = tag
            tagview.wantsLayer = true;
            
            tagview.layer?.backgroundColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:0.18).cgColor
            tagview.layer?.cornerRadius = 7
            let gesture = NSClickGestureRecognizer()
            gesture.buttonMask = 0x1 // left mouse
            gesture.numberOfClicksRequired = 2
            gesture.target = self
            gesture.action = #selector(remoteTag)
            
            tagview.addGestureRecognizer(gesture)
            self.addSubview(tagview)
            
        }
        let newSize = NSMakeSize(CGFloat(65*tags.count), 17)
        self.setFrameSize(newSize)
    }
    @objc func remoteTag(sender: NSGestureRecognizer) {
        if let label = sender.view as? NSTextField {
            let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
            appDelegate?.createView?.removeTag(tag: label.stringValue)
            appDelegate?.createView?.refreshTagListView()
        }
    }
    override func scrollWheel(with event: NSEvent) {
        if (parentScrollView != nil && taglist != nil) {
            var positionX = parentScrollView.documentVisibleRect.origin.x
            let positionY = parentScrollView.documentVisibleRect.origin.y
            let deltaY = event.deltaY * 2
            if positionX + deltaY < 0 {
                positionX = 0
            }
            else if positionX + deltaY > CGFloat(taglist.count * 65 - 150) {
                positionX = CGFloat(taglist.count * 65 - 150 < 0 ? 0 : taglist.count * 65 - 150)
            }
            else{
                positionX += deltaY
            }
            
            self.setBoundsOrigin(NSPoint(x: positionX, y: positionY))
//            self.parentScrollView.enclosingScrollView?.contentView.bounds.origin = NSPoint(x: 10.0, y: positionY)
            
//            (NSRect(x: positionX+event.deltaY,y: positionY,width: width,height: height))
            
        }
    }
}
