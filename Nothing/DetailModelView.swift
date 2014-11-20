//
//  DetailModelView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class DetailModelView {
    let task: Task
    
    init(_ task: Task) {
        self.task = task
    }

    var title : String {
        return self.task.title
    }
    
    var longDescription : String {
        return self.task.longDescription ?? ""
    }
    
    var noLongDescription : String {
        return "No description"
    }
    
    var hashtags = Array<HashtagDetector.Result>()
    func longDescription(font: UIFont) -> NSAttributedString {
        let desc = self.task.longDescription ?? ""
        
        var attributedText = NSMutableAttributedString(string: desc, attributes: [NSFontAttributeName: font])
        let hashtagAttributes = [NSForegroundColorAttributeName: UIColor.appBlueColor(), NSFontAttributeName: font]
        
        self.hashtags = HashtagDetector(desc).detect() as [HashtagDetector.Result]!
        for (text, range) in self.hashtags {
            attributedText.addAttributes(hashtagAttributes, range: range)
        }
        
        return attributedText
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
            
            return arriveOrLeaveString + " (" + distanceString + ") " + "- " + reminder.place.customName
        }
        
        return ""
    }
    
    var noLocationReminderDescription : String {
        return "Location is not set"
    }
    
    var dateReminderDescription : String {
        if let reminder = self.task.dateReminder {
            return NSDateFormatter.NTHStringFromDate(reminder.fireDate)
        }
        
        return ""
    }
    
    var noDateReminderDescription : String {
        return "Date is not set"
    }
    
    var isDateReminder : Bool {
        return self.task.dateReminder != nil
    }
    
    var isLocationReminder : Bool {
        return self.task.locationReminder != nil
    }
}