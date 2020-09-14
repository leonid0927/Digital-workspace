//
//  TaskViewModel.swift
//  DigitalWorkspace
//
//  Created by nice orca on 4/12/20.
//  Copyright © 2020 nice orca. All rights reserved.
//

import Foundation

class TaskViewModel: NSObject {
    
    // MARK: - Properties
    
    var tasks = [Task]()
    
    // MARK: - Init
    
    override init() {
        super.init()
        
    }
    
    
    
    // MARK: - Private Methods
    
    public func loadDummyData(tasks: [Task]) {
        self.tasks = tasks
    }
    
    
    
    func getTask(withID id: Int) -> Task? {
        return tasks.filter{ $0.id == id }.first
    }
    
    
    func removeTask(atIndex index: Int) {
        tasks.remove(at: index)
    }
    
    
    func sortTasks(ascending: Bool) {
        tasks.sort { (p1, p2) -> Bool in
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
