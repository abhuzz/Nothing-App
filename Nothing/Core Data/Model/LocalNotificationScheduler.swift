//
//  LocalNotificationHelper.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class LocalNotificationScheduler {
    
    class func scheduleNotification(task: Task) {
        /// Cancel notifications first
        self.cancelScheduledNotifications(task)

        /// Prepare for scheduling
        let taskObjectID = task.objectID.URIRepresentation().absoluteString!

        var schedule = false
        let notification = UILocalNotification()
        
        /// Schedlue with date
        if let reminder = task.dateReminderInfo {
            schedule = true
            notification.fireDate = reminder.fireDate
            notification.repeatInterval = reminder.repeatInterval
            notification.alertBody = task.title
        }
        
        /// Schedule
        if schedule {
            notification.userInfo = ["objectID": taskObjectID]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    class func cancelScheduledNotifications(task: Task) {
        let taskObjectID = task.objectID.URIRepresentation().absoluteString!

        /// Find existing local notification and cancel it
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            if let info = notification.userInfo as [NSObject: AnyObject]? {
                if let objectID = info["objectID"] as? String {
                    if objectID == taskObjectID {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                        break
                    }
                }
            }
        }
    }
}