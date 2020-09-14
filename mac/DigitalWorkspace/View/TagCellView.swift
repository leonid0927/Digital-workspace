//
//  TagCellView.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/21/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa

class TagCellView: NSTableCellView {
    
    @IBOutlet weak var TitleTextField: NSTextField!
    @IBOutlet weak var DueDateTextField: NSTextField!
    @IBOutlet weak var TagsTextField: NSTextField!
    @IBOutlet weak var SelectButton: NSButton!
    @IBOutlet weak var BottomView: NSView!
    var defaultColor: CGColor!
    var isSeleted: Bool!
    var task: Task!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.SelectButton.wantsLayer=true
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.SelectButton.layer?.backgroundColor = self.defaultColor
        self.SelectButton.layer?.borderWidth = 1.0
        self.SelectButton.layer?.borderColor = self.defaultColor
        self.SelectButton.layer?.cornerRadius = 7.5
        self.isSeleted = false
        self.BottomView.wantsLayer = true
        self.BottomView.layer?.backgroundColor = self.defaultColor
        // Drawing code here.
    }
    
    public func setTask(currentTask: Task){
        self.task = currentTask
        self.setTitle(title: currentTask.title ?? "There is not Title")
        self.setTags(tags: currentTask.tags ?? "")
        self.setStatus(status: currentTask.status ?? "")
        self.setDueDate(dueDate: currentTask.dueDate ?? "")
    }
    
    public func setTitle(title: String){
        self.TitleTextField.stringValue = title
    }
    
    public func setTags(tags: String){
        self.TagsTextField.stringValue = tags
    }
    public func getTask()->Task{
        return self.task
    }
    public func setStatus(status: String){
        if status == "1"{
            self.SelectButton.layer?.backgroundColor = self.defaultColor
        }
        else {
            self.SelectButton.layer?.backgroundColor = NSColor.white.cgColor
        }
    }
    
    public func setDueDate(dueDate: String){
        let dateStr = dueDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: Date())
        let tomorrowStr = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let mySubstring = String(dateStr.prefix(10)) // Hello
        if todayStr == mySubstring {
            self.DueDateTextField.stringValue = "Today"
        }
        else if tomorrowStr == mySubstring {
            self.DueDateTextField.stringValue = "Tomorrow"
        }
        else{
            self.DueDateTextField.stringValue = dueDate
        }
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

