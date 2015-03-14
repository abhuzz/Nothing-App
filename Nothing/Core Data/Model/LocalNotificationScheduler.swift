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
        for reminder in task.dateReminders {
            let notification = UILocalNotification()
            notification.fireDate = reminder.fireDate
            notification.repeatInterval = reminder.repeatInterval
            notification.alertBody = task.title
            notification.userInfo = ["uniqueIdentifier": task.uniqueIdentifier]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            println("scheduled notification: \(notification)")
        }
    }
    
    class func cancelScheduledNotifications(task: Task) {
        let taskUniqueIdentifier = task.uniqueIdentifier
        
        /// Find existing local notification and cancel it
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            if let info = notification.userInfo as [NSObject: AnyObject]? {
                if let uniqueIdentifier = info["uniqueIdentifier"] as? String {
                    if uniqueIdentifier == taskUniqueIdentifier {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                        break
                    }
                }
            }
        }
    }
}