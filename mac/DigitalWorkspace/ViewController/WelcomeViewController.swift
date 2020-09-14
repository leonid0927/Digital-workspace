//
//  WelcomeViewController.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/11/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa
import Alamofire
class WelcomeViewController: NSViewController {

    @IBOutlet var contentView: NSView!
    @IBOutlet weak var clockinButton: NSButton!
    @IBOutlet weak var MenuButton: NSButton!
    @IBOutlet weak var MessageBox: NSTextField!
    @IBOutlet weak var welcomeLabel: NSTextField!
    var defaultColor: CGColor!
    var timer = Timer()
    var firstName = ""
    let hostUrl = "https://carbonateapp.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.contentView.layer?.backgroundColor = NSColor.white.cgColor
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.clockinButton.wantsLayer = true
        self.clockinButton.layer?.masksToBounds = true
        self.clockinButton.layer?.borderWidth = 7.0
        self.clockinButton.layer?.borderColor = defaultColor
        self.clockinButton.layer?.cornerRadius = 61
        self.clockinButton.layer?.backgroundColor = NSColor.white.cgColor
        self.clockinButton.shadow = NSShadow()
        self.clockinButton.layer?.shadowOpacity = 0.03
        self.clockinButton.layer?.shadowColor = NSColor.black.cgColor
        self.clockinButton.layer?.shadowOffset = NSMakeSize(0, 5)
        self.MessageBox.isHidden = true
        self.welcomeLabel.wantsLayer = true
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.clockinButton.attributedTitle = NSAttributedString(string: "clock in", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        setName()
        initView();
    }
    public func initView(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if  appDelegate?.bAllowAttendance ?? false {
            self.clockinButton.isHidden = false
        }
        else {
            self.clockinButton.isHidden = true
            appDelegate?.tasksMeetingsRequest()
        }
    }
    public func clockin(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let token = appDelegate?.token ?? "invalid"
        
        let json: [String: Any] = ["token": token, "type": "in", "dataType": "json" ,"req-outlet-id": "0", "user_lat": "53.901594", "user_lon": "25.277648", "appType": "desktop"]
       self.showAlert(message: "Connecting...")
        self.clockinButton.isEnabled = false
        Alamofire.request(self.hostUrl + "/web-attendance", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showAlert(message: "Something went wrong.Please try again!")
//                    appDelegate?.logout()
                    self.clockinButton.isEnabled = true
                    return
                }
                let status = auth["status"] as? Int
                if status == 1 {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.clockinButton.isEnabled = true
                        return
                    }
                    let message = data["message"] as? String
                    appDelegate?.showAlert(message: message ?? "Action performed successfully!")
                    appDelegate?.clockinView?.keepinClockout()
                    appDelegate?.clockinView?.setIsTask(isTask: true)
                    appDelegate?.tasksMeetingsRequest()
                    self.clockinButton.isEnabled = true
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.clockinButton.isEnabled = true
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? Int
                    if error == 501 {
//                        appDelegate?.startCapture()
                        appDelegate?.clockinView?.keepinClockout()
                        appDelegate?.clockinView?.setIsTask(isTask: true)
                        appDelegate?.tasksMeetingsRequest()
                    }
                    else if error == 311 {
                        message = "You have been logged out."
                        appDelegate?.logout()
                    }
                    appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    self.clockinButton.isEnabled = true
                }
            }
            else{
                self.showAlert(message: "No internet connection!")
//                appDelegate?.logout()
                self.clockinButton.isEnabled = true
                return
            }
        })
    }
    @IBAction func onClickClockinButton(_ sender: NSButton) {
        self.clockin()
    }
    @IBAction func onClickMenuButton(_ sender: Any) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.logoutRequest()
    }
    public func setName(){
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        self.firstName = appDelegate?.firstName ?? ""
        self.welcomeLabel.stringValue = ("Welcome, " + self.firstName + ".")
        
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
}
