//
//  ActivityModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 5/13/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

public class Activity {
    var name: String
    var activity_minutes: Int
    var activity_percentage: Float
    var details: [Activity]
    init(){
        self.name = ""
        self.activity_minutes = 1
        self.activity_percentage = 0
        self.details = [Activity]()
    }
}
