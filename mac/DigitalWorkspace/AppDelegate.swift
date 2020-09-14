//
//  AppDelegate.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/9/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa
import Alamofire
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    var popover: NSPopover?
    var loginView: ViewController?
    var welcomeView: WelcomeViewController?
    var clockinView: ClockinViewController?
    var createView: CreateViewController?
    var token = ""
    var firstName: String!
    var lastName: String!
    var user_id: String!
    var screenshot_interval = 600
    var isClockin = false
    var isRemember = false
    var userOutletID = "0"
    var tasks = [Task]()
    var meetings = [Meeting]()
    var message = ""
    var timer = Timer()
    var autoChecker = Timer()
    var checkApplications = Timer();
    var bAllowAttendance = false
    var bAllowAddMeetingRoom = false
    var bAllowAddTask = false
    
    var BrowserScripts = [String: String]()
    var applist = [Activity]()
    var clockinMinutes: Float = 0.00
    let hostUrl = "https://carbonateapp.com"
    var totalTimefromclockin: Float = 0.00
    var in_checking_browser = false;
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    public func startCapture(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.screenshot_interval), target: self, selector: #selector(TakeScreensShots), userInfo: nil, repeats: true)
        checkApplications = Timer.scheduledTimer(timeInterval: TimeInterval(60), target: self, selector: #selector(Check_Applist), userInfo: nil, repeats: true)
    }
    public func startCheck(){
        print("start check")
        autoChecker.invalidate()
        autoChecker = Timer.scheduledTimer(timeInterval: TimeInterval(15), target: self, selector: #selector(AutoCheck_TickAsync), userInfo: nil, repeats: true)
    }
    
    public func stopCapture(){
        print("stop capture")
        timer.invalidate()
        checkApplications.invalidate()
    }
    public func stopCheck(){
        print("stop check")
        autoChecker.invalidate()
    }
    
    override init() {
        super.init()
        BrowserScripts["Google Chrome"] = "set r to \"\"\n" +
            "tell application \"Google Chrome\"\n" +
            "repeat with w in windows\n" +
            "repeat with t in tabs of w\n" +
            "tell t to set r to r & title & linefeed\n" +
            "end repeat\n" +
            "end repeat\n" +
            "end tell\n" +
        "return r"
        
        
        BrowserScripts["Safari"] = "set r to \"\"\n" +
            "tell application \"Safari\"\n" +
            "repeat with w in windows\n" +
            "if exists current tab of w then\n" +
            "repeat with t in tabs of w\n" +
            "tell t to set r to r & name & linefeed\n" +
            "end repeat\n" +
            "end if\n" +
            "end repeat\n" +
            "end tell\n" +
        "return r"
        
        timer.invalidate()
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.image = NSImage(named: "StatusIcon")
        statusBarItem?.button?.target = self
        initPopover()
        initStatusLoginItem()
    }
    public func applistInfoInit(){
        applist = self.openApplist()
        if applist.count == 0 {
            self.clockinMinutes = 0
            self.totalTimefromclockin = 0
        }
        else {
            var totalTimebeforeFinished = 0
            if applist.last?.name == "totalMinutes" {
                totalTimebeforeFinished = applist.last?.activity_minutes ?? 0
                applist.removeLast()
            }
            let modificationDate = self.fileModificationDate()
            let now = Date()
            let NowDateMinutes = now.timeIntervalSinceReferenceDate/60
            let OldDateMinutes = (modificationDate?.timeIntervalSinceReferenceDate ?? 0)/60
            var duringFromFinished = 0.00
            if OldDateMinutes > 0 {
                duringFromFinished = NowDateMinutes - OldDateMinutes
            }
            if duringFromFinished < 0 {
                duringFromFinished = 0
            }
            self.clockinMinutes = getClockinMinutes(applist: self.applist)
            if totalTimebeforeFinished == 0
            {
                totalTimebeforeFinished = Int(clockinMinutes)
            }
            self.totalTimefromclockin = Float(duringFromFinished) + Float(totalTimebeforeFinished)
            if(self.totalTimefromclockin >= 15)
            {
                uploadApplistInofRequest()
            }
        }
    }
    private func getClockinMinutes(applist: [Activity]) -> Float{
        for activity in applist{
            if(activity.activity_minutes > 0 && activity.activity_percentage > 0){
                return Float(activity.activity_minutes * 100) / activity.activity_percentage
            }
        }
        return 0
    }
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    public func logoutWithReport(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let token = appDelegate?.token ?? "invalid"
        var buffArray = [[String: Any]]()
        if applist.count > 0 {
            for activity in applist {
                var buff = [String:Any]()
                buff["name"] = activity.name
                buff["activity_minutes"] = activity.activity_minutes
                buff["activity_percentage"] = activity.activity_percentage
                var details = [[String: Any]]()
                for detail in activity.details {
                    var detailBuff = [String:Any]()
                    detailBuff["name"] = detail.name
                    detailBuff["activity_minutes"] = detail.activity_minutes
                    detailBuff["activity_percentage"] = detail.activity_percentage
                    details.append(detailBuff)
                }
                buff["details"] = details
                buffArray.append(buff)
            }
            var json: [String: String] = ["token": token, "type": "browser-activity", "dataType": "json", "appType": "desktop"]
            let jsonData = try! JSONSerialization.data(withJSONObject: buffArray, options:[])
            var jsonString: String!
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            json["activity"] = jsonString
            print(json)
            Alamofire.request(self.hostUrl + "/app-activity", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
                if response.result.isSuccess {
                    guard let auth = response.result.value as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    let status = auth["status"] as? Int
                    if status == 1 {
//                        if !self.isClockin {
//                            self.checkApplications.invalidate()
//                        }
                        self.totalTimefromclockin = 0
                        self.clockinMinutes = 0
                        do {
                            let applistFilePath = URL(fileURLWithPath: NSHomeDirectory() + "/DigitalWorkspace" + "/"+self.user_id+"_info.plist")
                            try FileManager.default.removeItem(at: applistFilePath)
                            self.applist = [Activity]()
                        } catch let error as NSError {
                            print("Error: \(error.domain)")
                        }
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
//                            self.checkApplications.invalidate()
                            message = "You have been logged out."
                            appDelegate?.logout()
                        }
                        appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    }
                }
                else{
                    self.showAlert(message: "No internet connection!")
                    return
                }
                self.logoutRequest()
            })
        }
        else {
//            if !self.isClockin {
//                self.checkApplications.invalidate()
//            }
            self.totalTimefromclockin = 0
            self.clockinMinutes = 0
            do {
                let applistFilePath = URL(fileURLWithPath: NSHomeDirectory() + "/DigitalWorkspace" + "/"+self.user_id+"_info.plist")
                try FileManager.default.removeItem(at: applistFilePath)
                self.applist = [Activity]()
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
            self.logoutRequest()
        }
    }
    public func logoutRequest(){
        self.isClockin = false
        self.stopCapture()
        self.stopCheck()
//        self.checkApplications.invalidate()
        self.clockinView?.stopRefreshMeetingTasks()
        let token = self.token
        let json: [String: Any] = ["token": token, "dataType": "json", "appType": "desktop"]
        self.showAlert(message: "Connecting...")
        Alamofire.request(self.hostUrl + "/logout", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showAlert(message: "Something went wrong.Please try again!")
                    return
                }
                print(auth)
                let status = auth["status"] as? String
                if status == "1" {
                    let message = "Logged out successfully"
                    self.showAlert(message: message )
                    self.logout()
                }
                else {
                    let message = "You have been logged out."
                    self.showAlert(message: message )
                    self.logout()
                }
            }
            else{
                self.showAlert(message: "You have been logged out.")
                self.logout()
                return
            }
        })
    }
    
    
    
    func fileModificationDate() -> Date? {
        do {
            let folderName = NSHomeDirectory() + "/DigitalWorkspace"
            let attr = try FileManager.default.attributesOfItem(atPath: folderName +  "/"+self.user_id+"_info.plist")
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    @objc public func Check_Applist() {
        let ws = NSWorkspace.shared
        let apps = ws.runningApplications
        print("----------start-----------")
        var currentApplist = [Activity]()
        if self.isClockin{
            
            for currentApp in apps
            {
                if(currentApp.activationPolicy == .regular){
                    let appName = currentApp.localizedName ?? ""
                    if appName == ""{
                        continue
                    }
                    var is_new = true;
                    var activity_details = Activity()
                    for activity in currentApplist{
                        if(activity.name == appName){
                            activity_details = activity
                            is_new = false
                            break
                        }
                    }
                    
                    if BrowserScripts.keys.contains(appName) && !in_checking_browser {
                        in_checking_browser = true
                        let myAppleScript = BrowserScripts[appName] ?? ""
                        var error: NSDictionary?
                        let scriptObject = NSAppleScript(source: myAppleScript)
                        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error) {
                            let tabnames = output.stringValue!
                            let buffArray = tabnames.components(separatedBy: "\n")
                            for tab in buffArray {
                                if tab != ""{
                                    var isContains = false
                                    for detail in activity_details.details{
                                        if(detail.name == tab){
                                            isContains = true
                                            break
                                        }
                                    }
                                    if !isContains {
                                        let detail = Activity()
                                        detail.name = tab
                                        activity_details.details.append(detail)
                                    }
                                }
                            }
                        } else if (error != nil) {
                            print("error: \(String(describing: error))")
                        }
                        in_checking_browser = false
                    }
                    if is_new {
                        activity_details.name = appName
                        currentApplist.append(activity_details)
                    }
                }
            }
            
            for currentActivity in currentApplist {
                var is_new = true
                for activity in applist{
                    if currentActivity.name == activity.name {
                        activity.activity_minutes += 1
                        is_new = false;
                        for currentDetail in currentActivity.details{
                            var is_new_detail = true
                            for realDetail in activity.details{
                                if currentDetail.name == realDetail.name {
                                    is_new_detail = false;
                                    realDetail.activity_minutes += 1
                                    break;
                                }
                            }
                            if is_new_detail {
                                activity.details.append(currentDetail)
                            }
                        }
                    }
                }
                if is_new{
                    applist.append(currentActivity)
                }
            }
            clockinMinutes += 1
            for activity in applist{
                if self.clockinMinutes > 0 {
                    activity.activity_percentage = Float(activity.activity_minutes) / self.clockinMinutes * 100
                    for detail in activity.details{
                        detail.activity_percentage = Float(detail.activity_minutes) / self.clockinMinutes * 100
                    }
                }
                else {
                    activity.activity_percentage = 0
                }
            }
            self.writeApplist(activities: applist)
        }
        print(applist)
        var buffArray = [[String: Any]]()
        for activity in applist {
            var buff = [String:Any]()
            buff["name"] = activity.name
            buff["activity_minutes"] = activity.activity_minutes
            buff["activity_percentage"] = activity.activity_percentage
            var details = [[String: Any]]()
            for detail in activity.details {
                var detailBuff = [String:Any]()
                detailBuff["name"] = detail.name
                detailBuff["activity_minutes"] = detail.activity_minutes
                detailBuff["activity_percentage"] = detail.activity_percentage
                details.append(detailBuff)
            }
            buff["details"] = details
            buffArray.append(buff)
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: buffArray, options:[])
        var jsonString: String!
        jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        report(text: jsonString)
        self.totalTimefromclockin += 1
        print(self.totalTimefromclockin)
        if self.totalTimefromclockin >= 15
        {
            uploadApplistInofRequest()
        }
        print("-----------end------------")
    }
    
    public func uploadApplistInofRequest(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let token = appDelegate?.token ?? "invalid"
        var buffArray = [[String: Any]]()
        if applist.count > 0{
            for activity in applist {
                var buff = [String:Any]()
                buff["name"] = activity.name
                buff["activity_minutes"] = activity.activity_minutes
                buff["activity_percentage"] = activity.activity_percentage
                var details = [[String: Any]]()
                for detail in activity.details {
                    var detailBuff = [String:Any]()
                    detailBuff["name"] = detail.name
                    detailBuff["activity_minutes"] = detail.activity_minutes
                    detailBuff["activity_percentage"] = detail.activity_percentage
                    details.append(detailBuff)
                }
                buff["details"] = details
                buffArray.append(buff)
            }
            var json: [String: String] = ["token": token, "type": "browser-activity", "dataType": "json", "appType": "desktop"]
            //        do {
            let jsonData = try! JSONSerialization.data(withJSONObject: buffArray, options:[])
            var jsonString: String!
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            json["activity"] = jsonString
            print(json)
            //        } catch {
            //            print(error.localizedDescription)
            //            return
            //        }
            
            
            Alamofire.request(self.hostUrl + "/app-activity", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
                if response.result.isSuccess {
                    guard let auth = response.result.value as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    let status = auth["status"] as? Int
                    
                    if status == 1 {
                        guard let data = auth["data"] as? [String: Any] else {
                            print("Something went wrong.Please try again!")
                            //                        //                        self.clockoutButton.isEnabled = true
                            return
                        }
                        let message = data["message"] as? String
                        print(message)
                        //                    //                    self.clockoutButton.isEnabled = true
                        //                    appDelegate?.showAlert(message: message ?? "Action performed successfully!")
//                        if !self.isClockin {
//                            self.checkApplications.invalidate()
//                        }
                        self.totalTimefromclockin = 0
                        self.clockinMinutes = 0
                        do {
                            let applistFilePath = URL(fileURLWithPath: NSHomeDirectory() + "/DigitalWorkspace" + "/"+self.user_id+"_info.plist")
                            try FileManager.default.removeItem(at: applistFilePath)
                            self.applist = [Activity]()
                        } catch let error as NSError {
                            print("Error: \(error.domain)")
                        }
                    }
                    else {
                        guard let data = auth["data"] as? [String: Any] else {
                            //self.showAlert(message: "Something went wrong.Please try again!")
                            //                        self.clockoutButton.isEnabled = true
                            return
                        }
                        var message = data["message"] as? String
                        let error  = auth["error"] as? Int
                        if error == 311 {
                            message = "You have been logged out."
                            appDelegate?.logout()
                            appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                        }
//                        appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    }
                }
                else{
                    //self.showAlert(message: "No internet connection!")
                    //                appDelegate?.logout()
                    //                self.clockoutButton.isEnabled = true
                    return
                }
            })
        }
        else {
//            if !self.isClockin {
//                self.checkApplications.invalidate()
//            }
            self.totalTimefromclockin = 0
            self.clockinMinutes = 0
        }
    }
    
    @objc public func AutoCheck_TickAsync() {
        print("check request")
        let token = self.token
        let json: [String: Any] = ["token": token, "dataType": "json", "appType": "desktop"]
        Alamofire.request(self.hostUrl + "/getLoginResponse", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
//                    self.showAlert(message: "Something went wrong.Please try again!")
                    return
                }
                let status = auth["status"] as? Int
                if status == 1 {
                    guard let data = auth["data"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    guard let session = data["session"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    let interval_str = data["screenshot_interval"] as! String
                    self.bAllowAttendance = data["bAllowAttendance"] as! Bool
                    
                    if self.screenshot_interval != Int(interval_str) ?? 0 {
                        self.screenshot_interval = Int(interval_str) ?? 0
                        self.startCapture()
                        self.stopCapture()
                    }
                    guard let user = session["User"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
//                    self.token = user["auth_token"] as! String
                    guard let UserOutlet = user["UserOutlet"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    self.userOutletID = UserOutlet["id"] as! String
                    self.firstName = user["first_name"] as? String
                    self.lastName = user["last_name"] as? String
                    self.welcomeView?.setName()
                    self.clockinView?.initView()
                    guard (data["last_check_in"] as? [String: Any]) != nil else {
                        self.stopCapture()
                        if self.isClockin && self.bAllowAttendance {
                            self.initStatusWelcomeItem()
                            self.welcomeView?.initView()
                        }
                        return
                    }
                    if !self.timer.isValid{
                        self.startCapture()
                    }
                    if !self.isClockin{
                        self.tasksMeetingsRequest()
                    }
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
//                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? String
                    if error == "311" {
                        message = "You have been logged out."
                        self.logout()
                    }
//                    self.showAlert(message: message ?? "Something went wrong.Please try again!")
                }
            }
            else{
//                self.showAlert(message: "No internet connection!")
//                self.logout()
            }
        })
    }
    
    public func tasksMeetingsRequest(){
        print("task meetings request")
        let token = self.token
        let userOutletId = self.userOutletID
        let json: [String: String] = ["token": token, "userOutletId": userOutletId, "dataType": "json", "appType": "desktop"]
        Alamofire.request(self.hostUrl + "/digital-workspace", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showAlert(message: "Something went wrong.Please try again!")
//                    self.logout()
                    return
                }
                let status = auth["status"] as? Int
                self.initStatusClockinItem()
                if status == 1 {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        return
                    }
                    self.bAllowAddMeetingRoom = data["bAllowAddMeetingRoom"] as! Bool
                    self.bAllowAddTask = data["bAllowAddTask"] as! Bool
                    self.clockinView?.initView()
                    let meetingRoomsJson = data["meetingRooms"] as? [[String: Any]] ?? nil
                    self.meetings.removeAll()
                    if meetingRoomsJson != nil {
                        for meetingRoomJson in meetingRoomsJson! {
                            var meeting: Meeting! = Meeting()
                            meeting.id = Int(meetingRoomJson["id"] as! String) ?? 0
                            meeting.link = meetingRoomJson["link"] as? String
                            meeting.image = meetingRoomJson["image"] as? String
                            meeting.allowEdit = meetingRoomJson["allowEdit"] as? String
                            meeting.timing = meetingRoomJson["timing"] as? String
                            meeting.image_prop = meetingRoomJson["image_prop"] as? String
                            meeting.name = meetingRoomJson["name"] as? String
                            meeting.platform = meetingRoomJson["platform"] as? String
                            self.meetings.append(meeting)
                        }
                    }
                    
                    
                    let tasksJson = data["tasks"] as? [[String: Any]] ?? nil
                    self.tasks.removeAll()
                    if tasksJson != nil{
                        for taskJson in tasksJson! {
                            var task: Task! = Task()
                            guard let schedule = taskJson["Schedule"] as? [String: Any] else{
                                self.showAlert(message: "Something went wrong.Please try again!")
                                return
                            }
                            task.id = Int(schedule["id"] as! String) ?? 0
                            task.title = (schedule["job_title"] as? String ?? "")
                            task.dueDate = (schedule["end_date"] as? String ?? "")
                            task.start_time = (schedule["start_time"] as? String ?? "")
                            task.end_time = (schedule["end_time"] as? String ?? "")
                            task.tags = (schedule["tags"] as? String ?? "")
                            task.status = (schedule["status"] as? String ?? "")
                            self.tasks.append(task)
                        }
                    }
                    self.clockinView?.refreshLists()
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
                        self.logout()
                    }
                    self.showAlert(message: message ?? "Something went wrong.Please try again!")
                }
            }
            else{
                self.showAlert(message: "No internet connection!")
//                self.logout()
            }
        })
    }
    
    @objc public func TakeScreensShots(){
        print("Capture start")
        let folderName: String
        folderName = NSHomeDirectory() + "/DigitalWorkspace"
        if !self.directoryExistsAtPath(folderName){
            let filemgr = FileManager.default
            do{
                try filemgr.createDirectory(atPath: folderName,withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Can't create Root Diretory.")
            }
        }
        do {
            var displayCount: UInt32 = 0;
            var result = CGGetActiveDisplayList(0, nil, &displayCount)
            if (result != CGError.success) {
                print("error: \(result)")
                return
            }
            let allocated = Int(displayCount)
            let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
            result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
            
            if (result != CGError.success) {
                print("error: \(result)")
                return
            }
            
            let fileUrl = URL(fileURLWithPath: folderName + "/temp.jpg")
            var screenShot:CGImage!
            screenShot = nil
            if (CGDisplayCreateImage(activeDisplays[0]) != nil) {
                screenShot = CGDisplayCreateImage(activeDisplays[0])
            } else {
                return
            }
            let bitmapRep = NSBitmapImageRep(cgImage: screenShot!)
            let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])
            if try jpegData?.write(to: fileUrl, options: .atomic) ?? nil == nil {
                print("jpeg Data has error")
                return
            }
        }
        catch {
            print("error: \(error)")
            return
        }
        let json: [String: String]
        
        json = ["token": token, "dataType": "json", "bMultipartFormDocuments": "true", "appType": "desktop"]
        
//        print(json)
//        self.showAlert(message: "uploading...")
        let logoUrl = URL(fileURLWithPath: folderName + "/temp.jpg")
        Alamofire.upload(multipartFormData: { (data: MultipartFormData) in
            for (key, value) in json {
                data.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            data.append(logoUrl, withName: "logo")
        }, to: self.hostUrl + "/save-screenshots") { [weak self] (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard
                        let auth = response.result.value as? [String: Any] else {
                            print("structure is not auth")
                            return
                        }
                    let status = auth["status"] as? Int
                    if status == 1 {
                        print("uploaded success")
                    }
                    else {
                        guard let data = auth["data"] as? [String: Any] else {
                            return
                        }
                        var message = data["message"] as? String
                        let error  = auth["error"] as? Int
                        if error == 311 {
                            message = "You have been logged out."
                            self?.logout()
                        }
//                        self?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
//                self?.showAlert(message: "No internet connection!")
//                self?.logout()
            }
        }
    }
    
    func CreateTimeStamp() -> Int32
    {
        return Int32(Date().timeIntervalSince1970)
    }
    
    public func logout(){
        self.isClockin = false
        self.stopCapture()
        self.stopCheck()
        self.clockinView?.stopRefreshMeetingTasks()
        self.token = ""
        self.screenshot_interval = 600
        if !self.isRemember {
            self.loginView?.emailText.stringValue = ""
            self.loginView?.passwordText.stringValue = ""
        }
        self.timer.invalidate()
//        self.checkApplications.invalidate()
        self.initStatusLoginItem()
    }
    public func initStatusWelcomeItem() {
        self.isClockin = false
        self.stopCapture()
        self.clockinView?.stopRefreshMeetingTasks()
        self.welcomeView?.initView()
        statusBarItem?.button?.action = #selector(showWelcomeVC)
        showWelcomeVC()
    }
    
    public func initStatusCreateItem() {
        self.clockinView?.stopRefreshMeetingTasks()
        statusBarItem?.button?.action = #selector(showCreateVC)
        showCreateVC()
    }
    
    public func popupCreateView(){
        showCreateVC()
    }
    
    public func initStatusClockinItem() {
        self.isClockin = true
        statusBarItem?.button?.action = #selector(showClockinVC)
        showClockinVC()
        self.clockinView?.refreshLists()
        self.clockinView?.startRefreshMeetingTasks()
    }
    
    public func initStatusLoginItem() {
        self.isClockin = false
        self.stopCapture()
        self.clockinView?.stopRefreshMeetingTasks()
        self.stopCheck()
        statusBarItem?.button?.action = #selector(showLoginVC)
        showLoginVC()
    }
    
    public func showAlert(message: String){
        self.loginView?.showalert(message: message)
        self.welcomeView?.showalert(message: message)
        self.clockinView?.showalert(message: message)
        self.createView?.showalert(message: message)
    }
    
    @objc fileprivate func showLoginVC() {
        guard let popover = popover, let button = statusBarItem?.button else { return
        }
        if loginView == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "loginVCID")) as? ViewController else { return }
            loginView = vc
        }
        popover.contentViewController = loginView
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    @objc fileprivate func showWelcomeVC() {
        guard let popover = popover, let button = statusBarItem?.button else { return
        }
        if welcomeView == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "welcomeVCID")) as? WelcomeViewController else { return }
            welcomeView = vc
        }
        popover.contentViewController = welcomeView
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    @objc fileprivate func showClockinVC() {
        guard let popover = popover, let button = statusBarItem?.button else { return
        }
        if clockinView == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "clockinVCID")) as? ClockinViewController else { return }
            clockinView = vc
        }
        popover.contentViewController = clockinView
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    @objc fileprivate func showCreateVC() {
        guard let popover = popover, let button = statusBarItem?.button else { return }
        if createView == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "createVCID")) as? CreateViewController else { return }
            createView = vc
        }
        popover.contentViewController = createView
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    fileprivate func initPopover() {
        popover = NSPopover()
        popover?.behavior = .transient
        popover?.setAccessibilityHidden(false)
    }
    
    
    
    func writeApplist(activities: [Activity]){
        var buffArray = [[String: Any]]()
        for activity in activities {
            var buff = [String:Any]()
            buff["name"] = activity.name
            buff["activity_minutes"] = activity.activity_minutes
            buff["activity_percentage"] = activity.activity_percentage
            var details = [[String: Any]]()
            for detail in activity.details {
                var detailBuff = [String:Any]()
                detailBuff["name"] = detail.name
                detailBuff["activity_minutes"] = detail.activity_minutes
                detailBuff["activity_percentage"] = detail.activity_percentage
                details.append(detailBuff)
            }
            buff["details"] = details
            buffArray.append(buff)
        }
        var buff = [String:Any]()
        buff["name"] = "totalMinutes"
        buff["activity_minutes"] = self.totalTimefromclockin
        buff["activity_percentage"] = 0
        buffArray.append(buff)
        let folderName = NSHomeDirectory() + "/DigitalWorkspace"
        if !self.directoryExistsAtPath(folderName){
            let filemgr = FileManager.default
            do{
                try filemgr.createDirectory(atPath: folderName,withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Can't create Root Diretory.")
            }
        }
        let fileUrl = URL(fileURLWithPath: folderName + "/"+self.user_id+"_info.plist") // Your path here
        (buffArray as NSArray).write(to: fileUrl, atomically: true)
    }
    
    func openApplist() -> [Activity] {
        var activities = [Activity]()
        let folderName = NSHomeDirectory() + "/DigitalWorkspace"
        if !self.directoryExistsAtPath(folderName){
            return activities
        }
        let fileUrl = URL(fileURLWithPath: folderName + "/" + self.user_id + "_info.plist") // Your path here
        let buffArray = NSArray(contentsOf: fileUrl) as? [[String: Any]]
        if buffArray == nil{
            return activities
        }
        for buff in buffArray!{
            let activity = Activity()
            activity.name = buff["name"] as? String ?? ""
            if activity.name == ""{
                continue
            }
            activity.activity_minutes = buff["activity_minutes"] as? Int ?? 0
            activity.activity_percentage = buff["activity_percentage"] as? Float ?? 0
            for detail_buff in buff["details"] as? [[String: Any]] ?? [[String: Any]](){
                let detail = Activity()
                detail.name = detail_buff["name"] as? String ?? ""
                if detail.name == ""{
                    continue
                }
                detail.activity_minutes = detail_buff["activity_minutes"] as? Int ?? 0
                detail.activity_percentage = detail_buff["activity_percentage"] as? Float ?? 0
                activity.details.append(detail)
            }
            activities.append(activity)
        }
        return activities
    }
    
    func report(text: String){
        let report_url = URL(fileURLWithPath: NSHomeDirectory() + "/DigitalWorkspace/report.log")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowStr = formatter.string(from: Date())
        let text_all = "---------------------" + nowStr + "---------------------\n" + text + "\n"
        guard let data = text_all.data(using: String.Encoding.utf8) else { return }
        if FileManager.default.fileExists(atPath: report_url.path) {
            if let fileHandle = try? FileHandle(forWritingTo: report_url) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: report_url, options: .atomicWrite)
        }
    }
}

