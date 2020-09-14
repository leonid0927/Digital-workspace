//
//  CreateViewController.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/11/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa
import Alamofire
class CreateViewController: NSViewController{
    @IBOutlet weak var grayMenuView: NSImageView!
    @IBOutlet var contentView: NSView!
    @IBOutlet weak var taskMenuButton: NSButton!
    @IBOutlet weak var meetingMenuButton: NSButton!
    @IBOutlet weak var createTaskButton: NSButton!
    @IBOutlet weak var createMeetingButton: NSButton!
    @IBOutlet weak var tomorrowButton: NSButton!
    @IBOutlet weak var addDateButton: NSButton!
//    @IBOutlet weak var addMeetingDateButton: NSButton!
    @IBOutlet weak var todayButton: NSButton!
//    @IBOutlet weak var nowButton: NSButton!
    @IBOutlet weak var followEmailText: NSTextField!
    @IBOutlet weak var MenuButton: NSButton!
    @IBOutlet weak var addTagButton: NSButton!
    @IBOutlet weak var bottomNsView: NSView!
    @IBOutlet weak var bottomNSViewMeeting: NSView!
//    @IBOutlet weak var bottomNSStartTimeView: NSView!
//    @IBOutlet weak var bottomNSEndTimeView: NSView!
    @IBOutlet weak var TagsSubView: NSView!
    @IBOutlet weak var TitleTaskTextField: NSTextField!
    @IBOutlet weak var MessageBox: NSTextField!
    @IBOutlet weak var TaskSubView: NSView!
    @IBOutlet weak var MeetingSubview: NSView!
    @IBOutlet weak var tagToAddTextField: NSTextField!
    @IBOutlet weak var DueDatePicker: NSDatePicker!
//    @IBOutlet weak var MeetingDatePicker: NSDatePicker!
    @IBOutlet weak var TitleMeetingTextField: NSTextField!
    @IBOutlet weak var LinkTextField: NSTextField!
    @IBOutlet weak var LogoTextField: NSTextField!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var topTitleText: NSTextField!
    var defaultColor: CGColor!
    var defaultNSColor: NSColor!
    @IBOutlet weak var TagListView: TagsView!
    @IBOutlet weak var taglistScrollView: NSScrollView!
    var grayColor: CGColor!
    var isTaskSeleted: Bool!
    var tags: [String]!
    var TaskID: String!
    var MeetingID: String!
    var seletedTaskCellview: TaskCellView?
    var seletedMeetingCellview: MeetingCellView?
    let hostUrl = "https://carbonateapp.com"
    @IBOutlet weak var PointViewTaskMenu: NSView!
    @IBOutlet weak var StartTimePicker: NSDatePicker!
    @IBOutlet weak var EndTimePicker: NSDatePicker!
    //    @IBOutlet weak var PointViewNow: NSView!
    
    @IBOutlet weak var PointViewMeetingMenu: NSView!
    @IBOutlet weak var PointViewToday: NSView!
    @IBOutlet weak var PointViewTomorrow: NSView!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.defaultNSColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1)
        self.grayColor = NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1).cgColor
        
        self.PointViewTaskMenu.wantsLayer = true
        self.PointViewTaskMenu.layer?.backgroundColor = self.defaultColor
        self.PointViewTaskMenu.layer?.cornerRadius = 2.5
        
        self.PointViewMeetingMenu.wantsLayer = true
        self.PointViewMeetingMenu.layer?.backgroundColor = self.defaultColor
        self.PointViewMeetingMenu.layer?.cornerRadius = 2.5
        
        self.PointViewToday.wantsLayer = true
        self.PointViewToday.layer?.backgroundColor = self.defaultColor
        self.PointViewToday.layer?.cornerRadius = 2.5
        
//        self.PointViewNow.wantsLayer = true
//        self.PointViewNow.layer?.backgroundColor = self.defaultColor
//        self.PointViewNow.layer?.cornerRadius = 2.5
        
        self.PointViewTomorrow.wantsLayer = true
        self.PointViewTomorrow.layer?.backgroundColor = self.defaultColor
        self.PointViewTomorrow.layer?.cornerRadius = 2.5
        
        self.grayMenuView.wantsLayer = true
        self.grayMenuView.layer?.backgroundColor = NSColor(calibratedRed: 243/255, green: 243/255, blue: 243/255, alpha:1).cgColor
        self.contentView.layer?.backgroundColor = NSColor.white.cgColor
        self.bottomNsView.wantsLayer = true
        self.bottomNsView.layer?.backgroundColor = self.defaultColor
        self.bottomNSViewMeeting.wantsLayer = true
        self.bottomNSViewMeeting.layer?.backgroundColor = self.defaultColor
//        self.bottomNSStartTimeView.wantsLayer = true
//        self.bottomNSStartTimeView.layer?.backgroundColor = self.defaultColor
//        self.bottomNSEndTimeView.wantsLayer = true
//        self.bottomNSEndTimeView.layer?.backgroundColor = self.defaultColor
        self.createTaskButton.wantsLayer = true
        self.createTaskButton.layer?.cornerRadius = 11.5
        self.createTaskButton.layer?.backgroundColor = self.defaultColor
        self.createTaskButton.shadow = NSShadow()
        self.createTaskButton.layer?.shadowOpacity = 0.16
        self.createTaskButton.layer?.shadowColor = grayColor
        self.createTaskButton.layer?.shadowOffset = NSMakeSize(0, 3)
        self.createMeetingButton.wantsLayer = true
        self.createMeetingButton.layer?.cornerRadius = 11.5
        self.createMeetingButton.layer?.backgroundColor = self.defaultColor
        self.createMeetingButton.shadow = NSShadow()
        self.createMeetingButton.layer?.shadowOpacity = 0.16
        self.createMeetingButton.layer?.shadowColor = grayColor
        self.createMeetingButton.layer?.shadowOffset = NSMakeSize(0, 3)
        self.MeetingSubview.isHidden = true
        self.TagListView.setScrollView(scrollView: self.taglistScrollView)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.backButton.attributedTitle = NSAttributedString(string: "Back", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        self.createTaskButton.attributedTitle = NSAttributedString(string: "CREATE TASK", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.createMeetingButton.attributedTitle = NSAttributedString(string: "CREATE MEETING", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.isTaskSeleted = true
        self.addTagButton.wantsLayer = true
        self.addTagButton.layer?.backgroundColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:0.18).cgColor
        self.addTagButton.layer?.cornerRadius = 6.5
        self.MessageBox.isHidden = true
        self.tags = [String]()
        self.TagListView.refresh(tags: self.tags)
        self.tagToAddTextField.isHidden = true
        self.DueDatePicker.isHidden = true
//        self.MeetingDatePicker.isHidden = true
        self.LinkTextField.wantsLayer = true
        self.LinkTextField.layer?.cornerRadius = 8
        self.LogoTextField.wantsLayer = true
        self.LogoTextField.layer?.cornerRadius = 8
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.numberOfClicksRequired = 2
        gesture.target = self
        gesture.action = #selector(onClickLogo)
        LogoTextField.addGestureRecognizer(gesture)
        self.addTagButton.attributedTitle = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor: NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        self.StartTimePicker.wantsLayer = true
        self.EndTimePicker.wantsLayer = true
        self.StartTimePicker.layer?.borderColor = self.defaultColor
        self.EndTimePicker.layer?.borderColor = self.defaultColor
        self.selectToday()
        
    }
    @IBAction func onClickMenuButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.logoutWithReport()
//        appDelegate?.logoutRequest()
    }
    @IBAction func onClickTasksMenuButton(_ sender: Any) {
        if !isTaskSeleted {
            if self.MeetingID == ""{
                setIsTask(isTask: true)
            }
        }
    }
    @IBAction func onClickMeetingsMenuButton(_ sender: Any) {
        if isTaskSeleted {
            if self.TaskID == ""{
                setIsTask(isTask: false)
            }
        }
    }
    public func setIsTask(isTask: Bool){
//        self.isTaskSeleted = isTask
//        self.clearAll()
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        if isTask
        {
            if !appDelegate!.bAllowAddTask {
                return
            }
            appDelegate?.clockinView?.setOnlyIsTask(isTask: true)
            self.TaskSubView.isHidden = false
            self.MeetingSubview.isHidden = true
            
            taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.isTaskSeleted = isTask
        }
        else{
            if !appDelegate!.bAllowAddMeetingRoom {
                return
            }
            appDelegate?.clockinView?.setOnlyIsTask(isTask: false)
            self.TaskSubView.isHidden = true
            self.MeetingSubview.isHidden = false
            taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.isTaskSeleted = isTask
        }
    }
    @IBAction func onClickBackButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.initStatusClockinItem()
    }
    @IBAction func onClickAddTagButton(_ sender: Any) {
        if self.tagToAddTextField.isHidden == false{
            if self.tagToAddTextField.stringValue != "" {
                tags.append(self.tagToAddTextField.stringValue)
                self.tagToAddTextField.stringValue = ""
                self.TagListView.refresh(tags: tags)
            }
            self.tagToAddTextField.isHidden = true
        }
        else{
            self.tagToAddTextField.isHidden = false
        }
    }
    public func setMeeting(meeting: Meeting){
        self.MeetingID = String(meeting.id ?? 0)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.topTitleText.stringValue = "Edit a..."
        self.createMeetingButton.attributedTitle = NSAttributedString(string: "UPDATE MEETING", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.TitleMeetingTextField.stringValue = meeting.name ?? ""
        self.LinkTextField.stringValue = meeting.link ?? ""
        self.LogoTextField.stringValue = self.hostUrl + meeting.image!
    }
    public func clearAll(){
        self.MeetingID = ""
        self.TitleMeetingTextField.stringValue = ""
        self.LinkTextField.stringValue = ""
        self.LogoTextField.stringValue = ""
        self.TaskID = ""
        self.TitleTaskTextField.stringValue = ""
        self.tags = [String]()
        self.tagToAddTextField.stringValue = ""
        self.tagToAddTextField.isHidden = true
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        let endtime = formatter.date(from:"11:59 PM")
        self.EndTimePicker.dateValue = endtime!
        let starttime = formatter.date(from:"12:00 AM")
        self.StartTimePicker.dateValue = starttime!
        self.TagListView.refresh(tags: self.tags)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.topTitleText.stringValue = "Create a..."
        self.createTaskButton.attributedTitle = NSAttributedString(string: "CREATE TASK", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.createMeetingButton.attributedTitle = NSAttributedString(string: "CREATE MEETING", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.addDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.tomorrowButton.attributedTitle = NSAttributedString(string: "Tomorrow", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.todayButton.attributedTitle = NSAttributedString(string: "Today", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.selectToday()
    }
    public func setTask(task: Task){
        self.TaskID = String(task.id ?? 0)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.topTitleText.stringValue = "Edit a..."
        self.createTaskButton.attributedTitle = NSAttributedString(string: "UPDATE TASK", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.TitleTaskTextField.stringValue = task.title ?? ""
        let tagsStr = task.tags
        if tagsStr != nil && tagsStr != ""{
            self.tags = tagsStr?.components(separatedBy: ",")
        }
        self.TagListView.refresh(tags: self.tags)
        let dateStr = task.dueDate!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: Date())
        let tomorrowStr = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let mySubstring = String(dateStr.prefix(10)) // Hello
        if todayStr == mySubstring {
            self.selectToday()
        }
        else if tomorrowStr == mySubstring {
            self.selectTomorrow()
        }
        else{
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            self.addDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
            self.tomorrowButton.attributedTitle = NSAttributedString(string: "Tomorrow", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
            self.todayButton.attributedTitle = NSAttributedString(string: "Today", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        }
        let start_time = task.start_time!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm:ss"
        var date = dateFormatter.date(from:start_time)!
        self.StartTimePicker.dateValue = date
        
        let end_time = task.end_time!
        dateFormatter.dateFormat = "HH:mm:ss"
        date = dateFormatter.date(from:end_time)!
        self.EndTimePicker.dateValue = date
        
        self.DueDatePicker.dateValue = formatter.date(from:mySubstring)!
    }
    public func showalert(message: String){
        self.MessageBox.stringValue = message
        self.MessageBox.isHidden = false
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(hideMessage), userInfo: nil, repeats: false)
        
    }
    public func showAlert(message: String){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.showAlert(message: message)
    }
    @objc func hideMessage()
    {
        self.MessageBox.isHidden = true
        timer.invalidate()
    }
    public func removeTag(tag: String){
        var newtags = [String]()
        for atag in tags{
            if atag != tag{
                newtags.append(atag)
            }
        }
        tags = newtags
        
    }
    public func refreshTagListView(){
        self.TagListView.refresh(tags: tags)
    }
    @IBAction func onClickNowButton(_ sender: Any) {
        self.selectNow()
    }
    @IBAction func onClickTodayButton(_ sender: Any) {
        self.selectToday()
    }
    public func selectToday(){
        let date = Date()
        DueDatePicker.dateValue = date
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.todayButton.attributedTitle = NSAttributedString(string: "Today", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.tomorrowButton.attributedTitle = NSAttributedString(string: "Tomorrow", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.addDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
    }
    public func selectNow(){
//        let date = Date()
//        MeetingDatePicker.dateValue = date
//        let pstyle = NSMutableParagraphStyle()
//        pstyle.alignment = .center
//        self.nowButton.attributedTitle = NSAttributedString(string: "Now", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
//        self.addMeetingDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
    }
    public func selectTomorrow(){
        let date = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
        DueDatePicker.dateValue = date!
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.todayButton.attributedTitle = NSAttributedString(string: "Today", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.tomorrowButton.attributedTitle = NSAttributedString(string: "Tomorrow", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.addDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
    }
    @IBAction func onClickTomorrowButton(_ sender: Any) {
        self.selectTomorrow()
    }
    @IBAction func onChangeDatapicker(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(hideDataPicker), userInfo: nil, repeats: false)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.addDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.tomorrowButton.attributedTitle = NSAttributedString(string: "Tomorrow", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.todayButton.attributedTitle = NSAttributedString(string: "Today", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
        
    }
    @IBAction func onChangeMeetingDatepicker(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(hideDataPicker), userInfo: nil, repeats: false)
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
//        self.addMeetingDateButton.attributedTitle = NSAttributedString(string: "Add date", attributes: [ NSAttributedString.Key.foregroundColor : defaultNSColor!, NSAttributedString.Key.paragraphStyle : pstyle ])
//        self.nowButton.attributedTitle = NSAttributedString(string: "Now", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.black, NSAttributedString.Key.paragraphStyle : pstyle ])
    }
    @IBAction func onClickAddDateButton(_ sender: Any) {
        if self.DueDatePicker.isHidden {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(hideDataPicker), userInfo: nil, repeats: false)
            self.DueDatePicker.isHidden = false
        }
        else{
            self.DueDatePicker.isHidden = true
        }
    }
    @objc func hideDataPicker()
    {
        self.DueDatePicker.isHidden = true
//        self.MeetingDatePicker.isHidden = true
        timer.invalidate()
    }
    
    @IBAction func onClickCreateMeetingButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        
        let token = appDelegate?.token ?? "invalid"
        let title = self.TitleMeetingTextField.stringValue
        var meetingLink = self.LinkTextField.stringValue
        meetingLink = meetingLink.trimmingCharacters(in: .whitespaces)
        if(title == ""){
            self.showalert(message: "Please fill in title job")
            return
        }
        if(meetingLink == ""){
            self.showalert(message: "Please fill in invite link")
            return
        }
        let json: [String: String]
        var preMsg = "Creating..."
        if self.MeetingID != "" && self.MeetingID != nil {
            json = ["meeting-id": self.MeetingID,"token": token, "dataType": "json", "meeting-title": title,"meeting-link": meetingLink,"bMultipartFormDocuments": "true", "appType": "desktop"]
            preMsg = "Updating..."
        }
        else{
            json = ["token": token, "dataType": "json", "meeting-title": title,"meeting-link": meetingLink,"bMultipartFormDocuments": "true", "appType": "desktop"]
        }
        self.showAlert(message: preMsg)
        
        let logoUrl = NSURL(fileURLWithPath: self.LogoTextField.stringValue)
        self.createMeetingButton.isEnabled = false
        Alamofire.upload(multipartFormData: { (data: MultipartFormData) in
            for (key, value) in json {
                data.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
//            if(logoUrl != nil){
                data.append(logoUrl as URL, withName: "logo")
//            }
        }, to: self.hostUrl + "/add-meeting-room") { [weak self] (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self?.createMeetingButton.isEnabled = true
                    guard
                        let auth = response.result.value as? [String: Any] else {
                            self?.showAlert(message: "Something went wrong.Please try again!")
                            return
                        }
                    let status = auth["status"] as? Int
                    if status == 1 {
//                        guard let data = auth["data"] as? [String: Any] else {
//                            self?.showAlert(message: "Something went wrong.Please try again!")
//                            return
//                        }
                        
                        var message = "Meeting created successfully!"
                        if self?.MeetingID != "" && self?.MeetingID != nil {
                            message = "Meeting updated successfully!"
                        }
                        self?.showAlert(message: message )
                        appDelegate?.tasksMeetingsRequest()
                    }
                    else {
                        guard let data = auth["data"] as? [String: Any] else {
                            self?.showAlert(message: "Something went wrong.Please try again!")
                            self?.createMeetingButton.isEnabled = true
                            return
                        }
                        var message = data["message"] as? String
                        let error  = auth["error"] as? Int
                        if error == 311 {
                            message = "You have been logged out."
                            appDelegate?.logout()
                        }
                        appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                        self?.createMeetingButton.isEnabled = true
                    }
                }
            case .failure( _):
                
                Alamofire.request(self!.hostUrl + "/add-meeting-room", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
                    if response.result.isSuccess {
                        self?.createMeetingButton.isEnabled = true
                        guard let auth = response.result.value as? [String: Any] else {
                            self?.showAlert(message: "Something went wrong.Please try again!")
                            return
                        }
                        let status = auth["status"] as? Int
                        if status == 1 {
//                            guard let data = auth["data"] as? [String: Any] else {
//                                self?.showAlert(message: "Something went wrong.Please try again!")
//                                return
//                            }
                            var message = "Meeting created successfully!"
                            if self?.MeetingID != "" && self?.MeetingID != nil {
                                message = "Meeting updated successfully!"
                            }
                            self?.showAlert(message: message )
                            appDelegate?.tasksMeetingsRequest()
                        }
                        else {
                            guard let data = auth["data"] as? [String: Any] else {
                                self?.showAlert(message: "Something went wrong.Please try again!")
                                return
                            }
                            var message = data["message"] as? String
                            let error  = auth["error"] as? Int
                            if error == 311 {
                                message = "You have been logged out."
                                appDelegate?.logout()
                            }
                            appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                        }
                    }
                    else{
                        self?.createMeetingButton.isEnabled = true
                        self?.showAlert(message: "No internet connection!")
//                        appDelegate?.logout()
                        return
                    }
                })
            }
        }
    }
    @IBAction func onClickCreateTaskButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        
        let token = appDelegate?.token ?? "invalid"
        let title = self.TitleTaskTextField.stringValue
        if(title == "" ){
            self.showalert(message: "Please fill in title job")
            return
        }
        var tagsString = ""
        if tags.count>0{
            var index = 0
            for tag in tags{
                tagsString += tag
                index += 1
                if index != tags.count{
                    tagsString += ","
                }
            }
        }
        let userOutletId = appDelegate?.userOutletID ?? "0"
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        let limitDatetimestr = "01 January 2000"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMMM yyyy"
        let limitDate = formatter.date(from:limitDatetimestr)
        
        let dueDate = formatter.string(from: DueDatePicker.dateValue)
        if DueDatePicker.dateValue < limitDate! {
            self.showalert(message: "Please select valid duedate")
            return
        }
        let weekday = Calendar.current.dateComponents([.weekday], from: DueDatePicker.dateValue).weekday! - 1
        formatter.dateFormat = "hh:mm a"
        let startTime = formatter.string(from: self.StartTimePicker.dateValue).lowercased()
        let endTime = formatter.string(from: self.EndTimePicker.dateValue).lowercased()
        let startPeriod = String(startTime.suffix(2))
        let endPeriod = String(endTime.suffix(2))
        let json: [String: String]
        var preMsg = "Creating..."
        if self.TaskID != "" && self.TaskID != nil {
            json = ["token": token, "user_outlet_ids": userOutletId, "dataType": "json", "job_title": title,"start_date": dueDate,"end_date": dueDate,"roster_duration": "timings","start_time": startTime,"start_period": startPeriod,"end_time": endTime,"end_period": endPeriod,"weekday": String(weekday),"roster_location": "outlet","tags": tagsString,"type": "2","schedule_id": self.TaskID, "appType": "desktop"]
            preMsg = "Updating..."
        }
        else{
            json = ["token": token, "user_outlet_ids": userOutletId, "dataType": "json", "userOutletId": userOutletId,"job_title": title,"start_date": dueDate,"end_date": dueDate,"roster_duration": "timings","start_time": startTime,"start_period": startPeriod,"end_time": endTime,"end_period": endPeriod,"weekday": String(weekday),"roster_location": "outlet","tags": tagsString,"type": "2", "appType": "desktop"]
        }
        self.createTaskButton.isEnabled = false
        self.showalert(message: preMsg)
        Alamofire.request(self.hostUrl + "/add-task", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showalert(message: "Something went wrong.Please try again!")
//                    appDelegate?.logout()
                    self.createTaskButton.isEnabled = true
                    return
                }
                
                let status = auth["status"] as? Int
                if status == 1 {
//                    guard let data = auth["data"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
//                        return
//                    }
                    var message = "Task created successfully!"
                    if self.TaskID != "" && self.TaskID != nil {
                        message = "Task updated successfully!"
                    }
                    self.showAlert(message: message )
                    appDelegate?.tasksMeetingsRequest()
                    self.createTaskButton.isEnabled = true
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? Int
                    if error == 311 {
                        message = "You have been logged out."
                        appDelegate?.logout()
                    }
                    appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    self.createTaskButton.isEnabled = true
                }
            }
            else{
                self.showAlert(message: "No internet connection!")
//                appDelegate?.logout()
                self.createTaskButton.isEnabled = true
                return
            }
        })
    }
    @objc func onClickLogo(sender: NSGestureRecognizer) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["png","jpg","ico","jpeg","gif"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                self.LogoTextField.stringValue = path
                
            }
        } else {
            // User clicked on "Cancel"
            appDelegate?.popupCreateView()
            return
        }
        appDelegate?.popupCreateView()
    }
    
}
