//
//  ClockinViewController.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/11/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa
import Alamofire
class ClockinViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var grayMenuView: NSImageView!
    @IBOutlet weak var footerMenuView: NSImageView!
    @IBOutlet var contentView: NSView!
    @IBOutlet weak var taskMenuButton: NSButton!
    @IBOutlet weak var notifyPointMettingView: NSView!
    @IBOutlet weak var notifyPointTaskView: NSView!
    @IBOutlet weak var meetingMenuButton: NSButton!
    @IBOutlet weak var plusButton: NSButton!
    @IBOutlet weak var clockoutButton: NSButton!
    @IBOutlet weak var menuButton: NSButton!
    @IBOutlet weak var emptyLabel: NSTextField!
    @IBOutlet weak var taskTableView: NSTableView!
    @IBOutlet weak var taskScrollView: NSScrollView!
    @IBOutlet weak var meetingScrollView: NSScrollView!
    @IBOutlet weak var EditButton: NSButton!
    @IBOutlet weak var meetingTableView: NSTableView!
    @IBOutlet weak var MessageBox: NSTextField!
    var defaultColor: CGColor!
    var grayColor: CGColor!
    var lightGrayColor: CGColor!
    var isTaskSeleted: Bool!
    var taskViewModel = TaskViewModel()
    var meetingViewModel = MeetingViewModel()
    var seletedTaskItem: Task!
    var seletedMeetingItem: Meeting!
    var seletedTaskCellview: TaskCellView?
    var seletedMeetingCellview: MeetingCellView?
    let hostUrl = "https://carbonateapp.com"
    var timer = Timer()
//    var keepClockout = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(keepoutClockout), userInfo: nil, repeats: false)
    var RefreshMeetingTasks = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.grayColor = NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1).cgColor
        self.lightGrayColor = NSColor(calibratedRed: 243/255, green: 243/255, blue: 243/255, alpha:1).cgColor
        self.notifyPointTaskView.wantsLayer = true
        self.notifyPointTaskView.layer?.backgroundColor = defaultColor
        self.notifyPointTaskView.layer?.cornerRadius = 2
        self.notifyPointTaskView.isHidden = true
        self.notifyPointMettingView.wantsLayer = true
        self.notifyPointMettingView.layer?.backgroundColor = defaultColor
        self.notifyPointMettingView.layer?.cornerRadius = 2
        self.notifyPointMettingView.isHidden = true
        self.grayMenuView.wantsLayer = true
        self.grayMenuView.layer?.backgroundColor = NSColor(calibratedRed: 243/255, green: 243/255, blue: 243/255, alpha:1).cgColor
        self.footerMenuView.wantsLayer = true
        self.footerMenuView.layer?.backgroundColor = NSColor(calibratedRed: 243/255, green: 243/255, blue: 243/255, alpha:1).cgColor
        self.contentView.layer?.backgroundColor = NSColor.white.cgColor
        self.plusButton.wantsLayer = true
        self.plusButton.layer?.backgroundColor = defaultColor
        self.plusButton.layer?.cornerRadius = 3
        self.clockoutButton.wantsLayer = true
        self.clockoutButton.layer?.cornerRadius = 3
        self.clockoutButton.layer?.backgroundColor = NSColor.white.cgColor
        self.clockoutButton.shadow = NSShadow()
        self.clockoutButton.layer?.shadowOpacity = 0.16
        self.clockoutButton.layer?.shadowColor = grayColor
        self.clockoutButton.layer?.shadowOffset = NSMakeSize(0, 3)
        self.isTaskSeleted = true
        //task table view
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.taskTableView.rowHeight = 51
        self.taskTableView.wantsLayer = true
        self.taskTableView.gridColor = NSColor.white
        
        self.meetingTableView.wantsLayer = true
        self.meetingScrollView.isHidden = true
        self.meetingTableView.delegate = self
        self.meetingTableView.dataSource = self
        self.meetingTableView.rowHeight = 51
        self.meetingScrollView.wantsLayer = true
        
        self.EditButton.wantsLayer = true
        self.EditButton.layer?.cornerRadius = 3
        self.EditButton.layer?.backgroundColor = self.lightGrayColor
        self.EditButton.isEnabled = false
        self.EditButton.image = NSImage(named: "EditIconDeselected")
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        self.taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        self.clockoutButton.attributedTitle = NSAttributedString(string: "CLOCK OUT", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        self.keepinClockout()
        
    }
    public func setIsTask(isTask: Bool){
        self.seletedTaskCellview?.deselect();
        self.seletedMeetingCellview?.deselect();
        self.seletedTaskItem = nil
        self.seletedMeetingItem = nil
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if isTask{
            self.isTaskSeleted = true
            if taskViewModel.tasks.count == 0 {
                taskScrollView.isHidden = true
                emptyLabel.stringValue = "Currently No task for you?"
            }
            else{
                taskScrollView.isHidden = false
            }
            self.meetingScrollView.isHidden = true
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            self.taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        }
        else{
            self.isTaskSeleted = false
            self.taskScrollView.isHidden = true
            if meetingViewModel.meetings.count == 0 {
                meetingScrollView.isHidden = true
                emptyLabel.stringValue = "Currently No meeting for you?"
            }
            else{
                meetingScrollView.isHidden = false
            }
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            self.taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor :NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        }
        appDelegate?.createView?.setIsTask(isTask: isTask)
        initView()
        self.EnableEdit()
    }
    public func setOnlyIsTask(isTask: Bool){
        if isTask{
            self.isTaskSeleted = true
            self.meetingScrollView.isHidden = true
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            self.taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        }
        else{
            self.isTaskSeleted = false
            self.taskScrollView.isHidden = true
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            self.taskMenuButton.attributedTitle = NSAttributedString(string: "Tasks", attributes: [ NSAttributedString.Key.foregroundColor :NSColor(calibratedRed: 153/255, green: 153/255, blue: 153/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
            self.meetingMenuButton.attributedTitle = NSAttributedString(string: "Meetings", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        }
    }
    @IBAction func onClickCreateButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.initStatusCreateItem()
        appDelegate?.createView?.clearAll()
    }
    @IBAction func onClickEditButton(_ sender: Any) {
        if self.isTaskSeleted {
            if self.seletedTaskItem == nil{
                self.showAlert(message: "Please select item to edit")
                return
            }
            let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
            appDelegate?.initStatusCreateItem()
            appDelegate?.createView?.clearAll()
            appDelegate?.createView?.setIsTask(isTask: self.isTaskSeleted)
            appDelegate?.createView?.setTask(task: self.seletedTaskItem)
        }
        else{
            if self.seletedMeetingItem == nil{
                self.showAlert(message: "Please select item to edit")
                return
            }
            let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
            appDelegate?.initStatusCreateItem()
            appDelegate?.createView?.clearAll()
            appDelegate?.createView?.setIsTask(isTask: self.isTaskSeleted)
            appDelegate?.createView?.setMeeting(meeting: self.seletedMeetingItem)
        }
    }
    public func initView() {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if self.isTaskSeleted {
            if appDelegate?.bAllowAddTask ?? false {
                self.EditButton.isHidden = false;
                self.plusButton.isHidden = false;
            }
            else{
                self.EditButton.isHidden = true;
                self.plusButton.isHidden = true;
            }
        }
        else {
            if appDelegate?.bAllowAddMeetingRoom ?? false {
                self.EditButton.isHidden = false;
                self.plusButton.isHidden = false;
            }
            else{
                self.EditButton.isHidden = true;
                self.plusButton.isHidden = true;
            }
        }
        if appDelegate?.bAllowAttendance ?? false {
            self.clockoutButton.isHidden = false
        }
        else{
            self.clockoutButton.isHidden = true
        }
    }
    public func refreshLists(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let tasks: [Task] = (appDelegate?.tasks ?? nil)!
        let meetings: [Meeting] = (appDelegate?.meetings ?? nil)!
        self.meetingViewModel.loadDummyData(meetings: meetings)
        self.taskViewModel.loadDummyData(tasks: tasks)
        self.meetingTableView.reloadData()
        self.taskTableView.reloadData()
        self.seletedTaskCellview?.deselect();
        self.seletedMeetingCellview?.deselect();
        self.seletedTaskItem = nil
        self.seletedMeetingItem = nil
        self.EditButton.isEnabled = false
        self.EditButton.image = NSImage(named: "EditIconDeselected")
        self.EditButton.layer?.backgroundColor = self.lightGrayColor
    }
    @IBAction func onClickClockoutButton(_ sender: Any) {
        clockout()
    }
    @IBAction func onClickMenuButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.logoutWithReport()
//        appDelegate?.logoutRequest()
    }
    
    @IBAction func onClickTaskButton(_ sender: Any) {
        self.setIsTask(isTask: true)
    }
    
    @IBAction func onClickMeetingButton(_ sender: Any) {
        self.setIsTask(isTask: false)
    }
    
    public func EnableEdit(){
        if(self.isTaskSeleted){
            if self.seletedTaskItem == nil{
                self.EditButton.isEnabled = false
//                self.EditButton.image = NSImage(named: "EditIconDeselected")
//                self.EditButton.layer?.backgroundColor = self.lightGrayColor
            }
            else{
                self.EditButton.isEnabled = true
//                self.EditButton.image = NSImage(named: "EditIcon")
//                self.EditButton.layer?.backgroundColor = self.defaultColor
            }
        }
        else{
            if self.seletedMeetingItem == nil{
                self.EditButton.isEnabled = false
//                self.EditButton.image = NSImage(named: "EditIconDeselected")
//                self.EditButton.layer?.backgroundColor = self.lightGrayColor
            }
            else{
                self.EditButton.isEnabled = true
//                self.EditButton.image = NSImage(named: "EditIcon")
//                self.EditButton.layer?.backgroundColor = self.defaultColor
            }
        }
    }
    
    public func startRefreshMeetingTasks(){
        RefreshMeetingTasks.invalidate()
        RefreshMeetingTasks = Timer.scheduledTimer(timeInterval: TimeInterval(50), target: self, selector: #selector(RefreshMeetingTasks_TickAsync), userInfo: nil, repeats: true)
    }
    public func stopRefreshMeetingTasks(){
        print("stop refreshing")
        RefreshMeetingTasks.invalidate()
    }
    @objc public func RefreshMeetingTasks_TickAsync(){
        print("start refresh meetingtasks")
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let token = appDelegate?.token ?? "invalid"
        let userOutletId = appDelegate?.userOutletID ?? "0"
        let json: [String: String] = ["token": token, "userOutletId": userOutletId, "dataType": "json", "appType": "desktop"]
        Alamofire.request(self.hostUrl + "/digital-workspace", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
//                    self.showAlert(message: "Something went wrong.Please try again!")
//                    appDelegate?.logout()
                    return
                }
                let status = auth["status"] as? Int
                if status == 1 {
                    guard let data = auth["data"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    appDelegate?.bAllowAddMeetingRoom = data["bAllowAddMeetingRoom"] as! Bool
                    appDelegate?.bAllowAddTask = data["bAllowAddTask"] as! Bool
                    self.initView()
                    let meetingRoomsJson = data["meetingRooms"] as? [[String: Any]] ?? nil
                    appDelegate?.meetings.removeAll()
                    if meetingRoomsJson != nil {
                        for meetingRoomJson in meetingRoomsJson!{
                            var meeting: Meeting! = Meeting()
                            meeting.id = Int(meetingRoomJson["id"] as! String) ?? 0
                            meeting.link = meetingRoomJson["link"] as? String
                            meeting.image = meetingRoomJson["image"] as? String
                            meeting.allowEdit = meetingRoomJson["allowEdit"] as? String
                            meeting.timing = meetingRoomJson["timing"] as? String
                            meeting.image_prop = meetingRoomJson["image_prop"] as? String
                            meeting.name = meetingRoomJson["name"] as? String
                            meeting.platform = meetingRoomJson["platform"] as? String
                            appDelegate?.meetings.append(meeting)
                        }
                    }
                    
                    
                    let tasksJson = data["tasks"] as? [[String: Any]] ?? nil
                    appDelegate?.tasks.removeAll()
                    if tasksJson != nil{
                        for taskJson in tasksJson!{
                            var task: Task! = Task()
                            guard let schedule = taskJson["Schedule"] as? [String: Any] else{
//                                self.showAlert(message: "Something went wrong.Please try again!")
                                return
                            }
                            task.id = Int(schedule["id"] as! String) ?? 0
                            task.title = (schedule["job_title"] as? String ?? "")
                            task.dueDate = (schedule["end_date"] as? String ?? "")
                            task.start_time = (schedule["start_time"] as? String ?? "")
                            task.end_time = (schedule["end_time"] as? String ?? "")
                            task.tags = (schedule["tags"] as? String ?? "")
                            task.status = (schedule["status"] as? String ?? "")
                            appDelegate?.tasks.append(task)
                        }
                    }
                    
                    let tasks: [Task] = (appDelegate?.tasks ?? nil)!
                    let meetings: [Meeting] = (appDelegate?.meetings ?? nil)!
                    self.meetingViewModel.loadDummyData(meetings: meetings)
                    self.taskViewModel.loadDummyData(tasks: tasks)
                    self.meetingTableView.reloadData()
                    self.taskTableView.reloadData()
                    self.seletedTaskCellview?.deselect();
                    self.seletedMeetingCellview?.deselect();
                    self.seletedTaskItem = nil
                    self.seletedMeetingItem = nil
                    self.EditButton.isEnabled = false
                    self.EditButton.image = NSImage(named: "EditIconDeselected")
                    self.EditButton.layer?.backgroundColor = self.lightGrayColor
                    self.initView()
                    self.EnableEdit()
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? Int
                    if error == 311 {
                        message = "You have been logged out."
                        appDelegate?.logout()
                        appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")

                    }
//                    appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                }
            }
            else{
//                self.showAlert(message: "No internet connection!")
//                appDelegate?.logout()
            }
        })
    }
    public func clockout(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let token = appDelegate?.token ?? "invalid"
        let json: [String: Any] = ["token": token, "type": "out", "dataType": "json" ,"req-outlet-id": "0", "user_lat": "53.901594", "user_lon": "25.277648", "appType": "desktop"]
       self.showAlert(message: "Connecting...")
        self.clockoutButton.isEnabled = false
        Alamofire.request(self.hostUrl + "/web-attendance", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            self.clockoutButton.isEnabled = true
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showAlert(message: "Something went wrong.Please try again!")
//                    self.clockoutButton.isEnabled = true
                    return
                }
                let status = auth["status"] as? Int
                if status == 1 {
//                    appDelegate?.checkApplications.invalidate()
                    appDelegate?.uploadApplistInofRequest()
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
//                        self.clockoutButton.isEnabled = true
                        return
                    }
                    let message = data["message"] as? String
                    appDelegate?.initStatusWelcomeItem()
//                    self.clockoutButton.isEnabled = true
                    appDelegate?.showAlert(message: message ?? "Action performed successfully!")
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
//                        self.clockoutButton.isEnabled = true
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? Int
                    if error == 311 {
                        message = "You have been logged out."
                        appDelegate?.logout()
                    }
                    else if error == 702{
                        self.keepinClockout()
                    }
                    else if error == 501{
                        appDelegate?.initStatusWelcomeItem()
                        appDelegate?.uploadApplistInofRequest()
//                        self.clockoutButton.isEnabled = true
                    }
                    appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                }
            }
            else{
                self.showAlert(message: "No internet connection!")
//                appDelegate?.logout()
//                self.clockoutButton.isEnabled = true
                return
            }
        })
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.taskTableView {
            if isTaskSeleted {
                if taskViewModel.tasks.count == 0 {
                    taskScrollView.isHidden = true
                    emptyLabel.stringValue = "Currently No task for you?"
                }
                else {
                    taskScrollView.isHidden = false
                }
            }
            else{
                taskScrollView.isHidden = true
            }
            return taskViewModel.tasks.count
        }
        else{
            if !isTaskSeleted {
                if meetingViewModel.meetings.count == 0 {
                    meetingScrollView.isHidden = true
                    emptyLabel.stringValue = "Currently No meeting for you?"
                }
                else{
                    meetingScrollView.isHidden = false
                }
            }
            else{
                meetingScrollView.isHidden = true
            }
            return meetingViewModel.meetings.count
        }
    }
    
    func restore(nsTable: NSTableView) {
        nsTable.isHidden = false
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableView == self.meetingTableView {
            let currentMeeting = meetingViewModel.meetings[row]
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "MeetingCellID")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? MeetingCellView else { return nil }
            cellView.setMeeting(meeting: currentMeeting)
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let today_result = dateFormatter.string(from: date)
            let dueDate = String(currentMeeting.timing?.prefix(8) ?? "")
            if today_result == dueDate{
                cellView.setTiming(timing: "Now")
            }
            else {
                cellView.setTiming(timing: currentMeeting.timing ?? "")
            }
            
            return cellView
        }
        else {
            let currentTask = taskViewModel.tasks[row]
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "TaskCellID")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? TaskCellView else { return nil }
            cellView.setTask(currentTask: currentTask)
            return cellView
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if tableView == self.meetingTableView {
            let selectedCell = tableView.view(atColumn: 0, row:row, makeIfNecessary:true) as! MeetingCellView
            if selectedCell.isSeleted {
                selectedCell.deselect()
                self.seletedMeetingItem = nil
                seletedMeetingCellview = nil
                self.EnableEdit()
            }
            else{
                for arow in 0..<tableView.numberOfRows {
                    let cell = tableView.view(atColumn: 0, row:arow, makeIfNecessary:true) as! MeetingCellView
                    cell.deselect()
                }
                selectedCell.select()
                seletedMeetingCellview = selectedCell
                self.seletedMeetingItem = selectedCell.getMeeting()
                self.EnableEdit()
            }
            return false
        }
        else{
            let selectedCell = tableView.view(atColumn: 0, row:row, makeIfNecessary:true) as! TaskCellView
            if selectedCell.isSeleted{
                selectedCell.deselect()
                self.seletedTaskItem = nil
                self.EnableEdit()
                seletedTaskCellview = nil
            }
            else{
                for arow in 0..<tableView.numberOfRows {
                    let cell = tableView.view(atColumn: 0, row:arow, makeIfNecessary:true) as! TaskCellView
                    cell.deselect()
                }
                selectedCell.select()
                seletedTaskCellview = selectedCell
                self.seletedTaskItem = selectedCell.getTask()
                self.EnableEdit()
            }
            return false
        }
        
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
    public func keepinClockout(){
//        self.clockoutButton.isEnabled = false
//        self.keepClockout.invalidate()
//        self.keepClockout = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(keepoutClockout), userInfo: nil, repeats: false)
    }
    @objc func keepoutClockout()
    {
//        self.clockoutButton.isEnabled = true
//        self.keepClockout.invalidate()
    }
}
