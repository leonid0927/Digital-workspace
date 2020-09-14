//
//  MeetingViewModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/12/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

class MeetingViewModel: NSObject {
    
    // MARK: - Properties
    
    var meetings = [Meeting]()
    
    // MARK: - Init
    
    override init() {
        super.init()
        
    }
    
    
    
    // MARK: - Private Methods
    
    public func loadDummyData(meetings: [Meeting]) {
        self.meetings = meetings
    }
    
    
//    
//    func getMeeting(withID id: Int) -> Meeting? {
//        return meetings.filter{ $0.id == id }.first
//    }
//    
    
    func removeMeeting(atIndex index: Int) {
        meetings.remove(at: index)
    }
    
    
    func sortMeeting(ascending: Bool) {
        meetings.sort { (p1, p2) -> Bool in
            guard let id1 = p1.id, let id2 = p2.id else { return true }
            if ascending {
                return id1 < id2
            } else {
                return id2 < id1
            }
        }
    }
    
    
    func getAvatarData(forUserWithID userID: Int?) -> Data? {
        guard let id = userID, let url = Bundle.main.url(forResource: "\(id)", withExtension: "png") else { return nil }
        return try? Data(contentsOf: url)
    }
}
