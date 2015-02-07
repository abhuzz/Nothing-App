//
//  NTHTaskInfo.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class NTHTaskInfo {
    class LocationReminder {
        var place: Place?
        var distance: Float = 0
        var onArrive: Bool = true
        
        init() {}
    }
    
    class DateReminder {
        var fireDate: NSDate?
        var repeatInterval: NSCalendarUnit = NSCalendarUnit.allZeros
        init() {}
    }
    
    var title = ""
    var description = ""
    var dateReminder = DateReminder()
    var locationReminder = LocationReminder()
    var connections = [Connection]()
    
    init() {}
    
    init(task: Task) {
        self.title = task.title
        self.description = task.longDescription ?? ""
        
        if let reminder = task.dateReminder {
            self.dateReminder.fireDate = reminder.fireDate
            self.dateReminder.repeatInterval = reminder.repeatInterval
        }
        
        if let reminder = task.locationReminder {
            self.locationReminder.place = reminder.place
            self.locationReminder.onArrive = reminder.onArrive
            self.locationReminder.distance = reminder.distance
        }
        
        self.connections = task.allConnections.allObjects as [Connection]
    }
}