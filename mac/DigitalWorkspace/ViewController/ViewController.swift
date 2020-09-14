//
//  ViewController.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/9/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Cocoa
import Alamofire
class ViewController: NSViewController {

    @IBOutlet var contentView: NSView!
    @IBOutlet weak var emailTextView: NSView!
    @IBOutlet weak var passwordTextView: NSView!
    @IBOutlet weak var emailText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var checkBoxButton: NSButton!
    @IBOutlet weak var MessageBox: NSTextField!
    @IBOutlet weak var remembermeButton: NSButton!
    @IBOutlet weak var forgotPasswordButton: NSButton!
    var statusBarItem: NSStatusItem!
    var defaultColor: CGColor!
    var greyColor: CGColor!
    var timer = Timer()
    var isRemember = false
    let hostUrl = "https://carbonateapp.com"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.loginButton.wantsLayer = true
        self.defaultColor = NSColor(calibratedRed: 106/255, green: 209/255, blue: 223/255, alpha:1).cgColor
        self.greyColor = NSColor(calibratedRed: 67/255, green: 79/255, blue: 91/255, alpha:1).cgColor
        self.loginButton.layer?.backgroundColor = defaultColor
        self.contentView.layer?.backgroundColor = NSColor.white.cgColor
        self.emailTextView.wantsLayer = true
        self.emailTextView.layer?.masksToBounds = true
        self.emailTextView.layer?.borderWidth = 1.0
        self.emailTextView.layer?.borderColor = defaultColor
        self.emailTextView.layer?.cornerRadius = 3
        self.passwordTextView.wantsLayer = true
        self.passwordTextView.layer?.masksToBounds = true
        self.passwordTextView.layer?.borderWidth = 1.0
        self.passwordTextView.layer?.borderColor = defaultColor
        self.passwordTextView.layer?.cornerRadius = 3
        self.loginButton.wantsLayer = true
        self.loginButton.layer?.masksToBounds = true
        self.loginButton.layer?.borderWidth = 1.0
        self.loginButton.layer?.borderColor = defaultColor
        self.loginButton.layer?.cornerRadius = 3
        self.checkBoxButton.wantsLayer = true
        self.checkBoxButton.layer?.masksToBounds = true
        self.checkBoxButton.layer?.borderWidth = 1.0
        self.checkBoxButton.layer?.borderColor = defaultColor
        self.MessageBox.isHidden = true
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        self.remembermeButton.attributedTitle = NSAttributedString(string: "Remember me", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 67/255, green: 79/255, blue: 91/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        self.loginButton.attributedTitle = NSAttributedString(string: "LOG IN", attributes: [ NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.paragraphStyle : pstyle ])
        self.forgotPasswordButton.attributedTitle = NSAttributedString(string: "Forgot Password?", attributes: [ NSAttributedString.Key.foregroundColor : NSColor(calibratedRed: 67/255, green: 79/255, blue: 91/255, alpha:1), NSAttributedString.Key.paragraphStyle : pstyle ])
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let credential = getCredential()
        self.emailText.stringValue = credential.email ?? ""
        self.passwordText.stringValue = credential.password  ?? ""
        if self.emailText.stringValue == "" {
            appDelegate?.isRemember = false
            isRemember = false
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = NSColor.white.cgColor
        }
        else{
            isRemember = true
            appDelegate?.isRemember = true
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = self.defaultColor
        }
    }
    
    func rememberCredential(credential: Credential){
        let folderName = NSHomeDirectory() + "/DigitalWorkspace"
        if !self.directoryExistsAtPath(folderName){
            let filemgr = FileManager.default
            do{
                try filemgr.createDirectory(atPath: folderName,withIntermediateDirectories: true, attributes: nil)
            } catch {
                self.showAlert(message: "Can't create Root Diretory.")
            }
        }
        
        var buffArray = [String]()
        buffArray.append(credential.email ?? "")
        buffArray.append(credential.password ?? "")
        let fileUrl = URL(fileURLWithPath: folderName + "/remembered.plist") // Your path here
        (buffArray as NSArray).write(to: fileUrl, atomically: true)
    }
    
    func getCredential() -> Credential{
        var credential = Credential()
        let folderName = NSHomeDirectory() + "/DigitalWorkspace"
        if !self.directoryExistsAtPath(folderName){
            return credential
        }
        let fileUrl = URL(fileURLWithPath: folderName + "/remembered.plist") // Your path here
        let buffArray = NSArray(contentsOf: fileUrl) as? [String]
        if buffArray == nil{
            return credential
        }
        credential.email = buffArray?[0]
        credential.password = buffArray?[1]
        return credential
    }
    
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    @IBAction func onClickCheckBox(_ sender: NSButton) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if appDelegate?.isRemember ?? false || self.isRemember {
            appDelegate?.isRemember = false
            self.isRemember = false
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = NSColor.white.cgColor
        }
        else{
            appDelegate?.isRemember = true
            self.isRemember = true
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = self.defaultColor
        }
    }
    
    @IBAction func onClickFogotButton(_ sender: Any) {
        let url = URL(string: self.hostUrl + "/forget-password")
        NSWorkspace.shared.open(url!)
    }
    @IBAction func onClickRememberBox(_ sender: NSButton) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if appDelegate?.isRemember ?? false || self.isRemember {
            appDelegate?.isRemember = false
            self.isRemember = false
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = NSColor.white.cgColor
        }
        else{
            self.isRemember = true
            appDelegate?.isRemember = true
            self.checkBoxButton.wantsLayer = true
            self.checkBoxButton.layer?.masksToBounds = true
            self.checkBoxButton.layer?.borderWidth = 1.0
            self.checkBoxButton.layer?.backgroundColor = self.defaultColor
        }
    }
    @IBAction func onClickLoginButton(_ sender: NSButton) {
        self.showAlert(message: "Connecting...")
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        if isRemember || appDelegate?.isRemember ?? false {
            appDelegate?.isRemember = true
            self.isRemember = true
            var credential = Credential()
            credential.email = self.emailText.stringValue
            credential.password = self.passwordText.stringValue
            self.rememberCredential(credential: credential)
        }
        else{
            appDelegate?.isRemember = false
            self.isRemember = false
            var credential = Credential()
            credential.email = ""
            credential.password = ""
            self.rememberCredential(credential: credential)
        }
        let email: String = self.emailText.stringValue
        let password: String = self.passwordText.stringValue
        if email == "" {
            self.showAlert(message: "Provide valid a email address")
            return
        }
        if password == "" {
            self.showAlert(message: "Provide a password")
            return
        }
        self.login(password: password, email: email)
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
    public func login(password: String, email: String) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        let json: [String: Any] = ["email": email, "password": password, "dataType": "json", "desktopApp": "1", "appType": "desktop"]
        self.loginButton.isEnabled = false;
        Alamofire.request(self.hostUrl + "/login", method: .post, parameters: json).validate().responseJSON(completionHandler: { (response :DataResponse<Any>) in
            if response.result.isSuccess {
                guard let auth = response.result.value as? [String: Any] else {
                    self.showAlert(message: "Something went wrong.Please try again!")
                    self.loginButton.isEnabled = true;
                    return
                }
                
                let status = auth["status"] as? Int
                if status == 1 {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.loginButton.isEnabled = true;
                        return
                    }
                    guard let session = data["session"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.loginButton.isEnabled = true;
                        return
                    }
                    let interval_str = data["screenshot_interval"] as! String
                    appDelegate?.bAllowAttendance = data["bAllowAttendance"] as! Bool
                    appDelegate?.welcomeView?.initView()
                    appDelegate?.screenshot_interval = Int(interval_str) ?? 0
                    guard let user = session["User"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.loginButton.isEnabled = true;
                        return
                    }
                    appDelegate?.token = user["auth_token"] as! String
                    guard let UserOutlet = user["UserOutlet"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.loginButton.isEnabled = true;
                        return
                    }
                    appDelegate?.startCheck()
                    
                    appDelegate?.userOutletID = UserOutlet["id"] as! String
                    appDelegate?.firstName = user["first_name"] as? String
                    appDelegate?.lastName = user["last_name"] as? String
                    appDelegate?.user_id = user["id"] as? String
                    appDelegate?.applistInfoInit()
                    appDelegate?.welcomeView?.setName()
                    guard (data["last_check_in"] as? [String: Any]) != nil else {
                        if appDelegate?.bAllowAttendance ?? false {
                            appDelegate?.initStatusWelcomeItem()
                            self.loginButton.isEnabled = true;
                        }
                        else{
                            appDelegate?.clockinView?.keepinClockout()
                            appDelegate?.clockinView?.setIsTask(isTask: true)
                            appDelegate?.tasksMeetingsRequest()
                            appDelegate?.welcomeView?.setName()
                            self.loginButton.isEnabled = true;
                        }
                        return
                    }
//                    appDelegate?.startCapture()
                    appDelegate?.clockinView?.keepinClockout()
                    appDelegate?.clockinView?.setIsTask(isTask: true)
                    appDelegate?.tasksMeetingsRequest()
                    appDelegate?.welcomeView?.setName()
                    self.loginButton.isEnabled = true;
                }
                else {
                    guard let data = auth["data"] as? [String: Any] else {
                        self.showAlert(message: "Something went wrong.Please try again!")
                        self.loginButton.isEnabled = true;
                        return
                    }
                    var message = data["message"] as? String
                    let error  = auth["error"] as? Int
                    if error == 311 {
                        message = "You have been logged out."
                        appDelegate?.logout()
                    }
                    appDelegate?.showAlert(message: message ?? "Something went wrong.Please try again!")
                    self.loginButton.isEnabled = true;
                }
            }
            else{
                self.loginButton.isEnabled = true;
                self.showAlert(message: "No internet connection!")
            }
        })
    }
    @objc func onClickLogo(sender: NSGestureRecognizer) {
        self.passwordText.stringValue = ""
    }
}

