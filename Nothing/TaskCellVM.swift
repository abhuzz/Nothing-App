//
//  TaskCellViewModel.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class TaskCellVM {
    let task: Task
    init (_ task: Task) {
        self.task = task
    }
    
    var title: String { return self.task.title }
    
    var description: String { return self.task.longDescription ?? "" }
    
    var datePlaceDescription: String {
        var value = ""
        if let reminder = self.task.dateReminderInfo {
            value += self.dateFormatter.stringFromDate(reminder.fireDate)
        }
        
        if let reminder = self.task.locationReminderInfo {
            if countElements(value) > 0 {
                value += " "
            }
            
            value += "@ \(reminder.place.customName)"
        }
        
        return value
    }
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM yyyy hh:mm"
        return formatter
    }()
    
    lazy var titleLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)!
        attr.textColor = UIColor.appBlack()
        return attr
    }()
    
    lazy var descriptionLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        attr.textColor = UIColor.appBlack()
        attr.numberOfLines = 4
        return attr
    }()
    
    lazy var datePlaceLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        attr.textColor = UIColor.appWhite186()
        return attr
    }()
}