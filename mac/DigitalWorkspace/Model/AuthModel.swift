//
//  AuthModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/17/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

struct Auth: Codable {
    var status: Int?
    var error: String?
    var data: AuthData?
}
struct AuthData: Codable {
    var authToken: String?
    var track_imei_no: String?
    var screenshot_interval: String?
    var message: String?
    var session: Session?
    var meetings: [Meeting]?
//    var tasks: [TaskRoom]?
}
struct Session: Codable{
    var user: User?
}
struct User: Codable {
    var id: String?
    var email: String?
    var image: String?
    var auth_token: String?
    var UserOutlet: [String: String]?
}
