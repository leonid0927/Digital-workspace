//
//  MeetingCellView.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/19/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa

class MeetingCellView: NSTableCellView {

    @IBOutlet weak var MeetingImageView: NSImageView!
    @IBOutlet weak var TitleTextField: NSTextField!
    @IBOutlet weak var DueDateTextfield: NSTextField!
    @IBOutlet weak var PlatformTextfield: NSTextField!
    @IBOutlet weak var GoButton: NSButton!
    @IBOutlet weak var LinkButton: NSButton!
    @IBOutlet weak var BottomView: NSView!
    var isSeleted: Bool!
    var inviteLink: String!
    var defaultColor: CGColor!
    var meeting: Meeting!
    let hostUrl = "https://carbonateapp.com"
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.GoButton.wantsLayer = true
        self.BottomView.wantsLayer = true
        self.BottomView.layer?.backgroundColor = self.defaultColor
        self.MeetingImageView.wantsLayer = true;
        self.MeetingImageView.layer?.cornerRadius = 12
        self.isSeleted = false
        // Drawing code here.
    }
    
    public func setImage(image: String){
        let imageUrl = URL(string: self.hostUrl + image)!
        self.MeetingImageView.image = NSImage(byReferencing: imageUrl)
    }
    
    public func setMeeting(meeting: Meeting){
        self.meeting = meeting
        self.setImage(image: meeting.image ?? "")
        self.setTitle(title: meeting.name ?? "title")
        self.setPlatform(platform: meeting.platform ?? "")
        self.setTiming(timing: meeting.timing ?? "")
        self.setInviteLink(link: meeting.link ?? "")
    }
    
    public func getMeeting()->Meeting{
        return self.meeting
    }
    public func setTitle(title: String){
        self.TitleTextField.stringValue = title
    }
    
    public func setTiming(timing: String){
        self.DueDateTextfield.stringValue = timing
    }
    public func setInviteLink(link: String){
        self.inviteLink = link
    }
    @IBAction func SaveClipboard(_ sender: NSButton) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(self.inviteLink ?? "", forType: .string)
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.clockinView?.showAlert(message: "Link copied to clipboard!")
    }
    @IBAction func GoLink(_ sender: Any) {
        
        if self.inviteLink.lowercased().range(of:"http://") != nil || self.inviteLink.lowercased().range(of:"https://") != nil{
            let url = URL(string: self.inviteLink ?? "")
            if url != nil{
                NSWorkspace.shared.open(url!)
            }else {
                let url = URL(string: self.hostUrl)
                NSWorkspace.shared.open(url!)
            }
        }
        else if self.inviteLink.lowercased().range(of:".") != nil {
            let url = URL(string: "http://"+self.inviteLink)
            if url != nil{
                NSWorkspace.shared.open(url!)
            }else {
                let url = URL(string: self.hostUrl)
                NSWorkspace.shared.open(url!)
            }
        }
        else{
            let url = URL(string: self.hostUrl + "/"+self.inviteLink)
            if url != nil{
                NSWorkspace.shared.open(url!)
            }else {
                let url = URL(string: self.hostUrl)
                NSWorkspace.shared.open(url!)
            }
            
        }
    }
    public func setPlatform(platform: String){
        self.PlatformTextfield.stringValue = platform
    }
    public func select(){
        if(self.isSeleted){
            
            self.isSeleted = false
            self.TitleTextField.textColor = NSColor.black
        }
        else{
            
            self.TitleTextField.textColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1)
            self.isSeleted = true
        }
    }
    
    public func deselect(){
        
        self.isSeleted = false
        self.TitleTextField.textColor = NSColor.black
        
    }
}
