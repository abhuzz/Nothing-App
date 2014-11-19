//
//  DetailModelView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class DetailModelView {
    let task: Task
    
    init(_ task: Task) {
        self.task = task
    }

    var title : String {
        return self.task.title
    }
    
    var longDescription : String {
        return self.task.longDescription ?? "No description"
    }
    
    var isDescription : Bool {
        if let value = self.task.longDescription {
            return countElements(value) > 0
        }
        return false
    }
    
    var locationReminderDescription : String {
        if let reminder = self.task.locationReminder {
            var arriveOrLeaveString = (reminder.onArrive ? "Arrive" : "Leave")
        
            var distanceString = ""
            if reminder.distance >= 1000 {
                distanceString = "\(reminder.distance / 1000.0) km"
            } else {
                distanceString = "\(reminder.distance) m"
            }
            
            return arriveOrLeaveString + "(" + distanceString + ")" + ":" + reminder.place.customName
        }
        
        return "Location is not set"
    }
    
    var isDateReminder : Bool {
        return self.task.dateReminder != nil
    }
    
    var isLocationReminder : Bool {
        return self.task.locationReminder != nil
    }
}