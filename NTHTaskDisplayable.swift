//
//  NTHTaskDisplayable.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

/**
    This struct contains couple of object that are presented to the user, e.g. strings, numbers
*/
class NTHTaskDisplayable {
    var task: Task
    
    init(task: Task) {
        self.task = task
    }

    lazy var taskTitle: String = {
        return self.task.title
    }()
    
    lazy var taskDescription: String? = {
        return self.task.longDescription
    }()
    
    lazy var taskStateDescription: String = {
        switch self.task.state {
            case Task.State.Active:
                return NSLocalizedString("Active", comment: "")
            case Task.State.Done:
                return NSLocalizedString("Done", comment: "")
        }
    }()
    
    lazy var nameOfLocationInReminder: String? = {
        return self.task.locationReminder?.place.customName
    }()
    
    lazy var distanceString: String? = {
        if let reminder = self.task.locationReminder {
            return "\(reminder.distance) m"
        }
        
        return nil
    }()
    
    lazy var arriveOrLeaveString: String? = {
        if let reminder = self.task.locationReminder {
            return reminder.onArrive ? NSLocalizedString("Arrive", comment: "") : NSLocalizedString("Leave", comment: "")
        }
        
        return nil
    }()
    
    lazy var dateStringInReminder: String? = {
        if let reminder = self.task.dateReminder {
            return NSDateFormatter.NTHStringFromDate(reminder.fireDate)
        }
        
        return nil
    }()
    
    lazy var repeatString: String? = {
        if let reminder = self.task.dateReminder {
            switch reminder.repeatInterval {
            case NSCalendarUnit.CalendarUnitDay: return NSLocalizedString("Daily", comment: "")
            case NSCalendarUnit.CalendarUnitWeekOfMonth: return NSLocalizedString("Weekly", comment: "")
            case NSCalendarUnit.CalendarUnitMonth: return NSLocalizedString("Once a month", comment: "")
            case NSCalendarUnit.CalendarUnitYear: return NSLocalizedString("Once a year", comment: "")
            case NSCalendarUnit.allZeros: return NSLocalizedString("None", comment: "")
            default: break
            }
        }
        
        return nil
    }()
}
