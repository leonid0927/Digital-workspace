//
//  TaskModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/12/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

struct Task: Codable {
    var id: Int?
    var title: String?
    var dueDate: String?
    var tags: String?
    var weekday: String?
    var start_date: String?
    var end_date: String?
    var start_time: String?
    var end_time: String?
    var start_period: String?
    var end_period: String?
    var status: String?
}
