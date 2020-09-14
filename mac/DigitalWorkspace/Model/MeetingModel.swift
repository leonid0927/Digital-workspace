//
//  MeetingModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/12/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

struct Meeting: Codable {
    var name: String?
    var id: Int?
    var link: String?
    var platform: String?
    var allowEdit: String?
    var image: String?
    var timing: String?
    var image_prop: String?
}
