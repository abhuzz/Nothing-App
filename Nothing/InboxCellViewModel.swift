//
//  InboxCellVM.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class InboxCellViewModel {
    let task: Task

    init(_ task: Task) {
        self.task = task
    }
    
    func title() -> String {
        return self.task.title
    }
    
    func longDescription() -> String {
        return self.task.longDescription ?? ""
    }
    
    func dateAndPlace() -> String {
        var value = ""
        if let reminder = self.task.dateReminder {
            value += NSDateFormatter.NTHStringFromDate(reminder.fireDate)
        }
        
        if let reminder = self.task.locationReminder {
            if countElements(value) > 0 {
                value += " "
            }
            
            value += "@ \(reminder.place.customName)"
        }
        
        return value
    }
    
    private var isDone: Bool {
        return self.task.state == .Done
    }
    
    var stateButtonImage : UIImage {
        return self.isDone ? self.doneStateImage : self.undoneStateImage
    }
    
    var undoneStateImage : UIImage {
        return UIImage(named: "task-state-undone")!
    }
    
    var doneStateImage : UIImage {
        return UIImage(named: "task-state-done")!
    }
}