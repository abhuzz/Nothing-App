//
//  InboxCellVM.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class InboxCellVM {
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
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd MMM yyyy hh:mm"
            value += formatter.stringFromDate(reminder.fireDate)
        }
        
        if let reminder = self.task.locationReminder {
            if countElements(value) > 0 {
                value += " "
            }
            
            value += "@ \(reminder.place.customName)"
        }
        
        return value
    }
    
    func connectionsImages() -> [UIImage] {
        var images = [UIImage]()
        for connection in self.task.allConnections.allObjects as [Connection] {
            if let key = connection.thumbnailKey {
                if let data = ThumbnailCache.sharedInstance.read(key) {
                    let image = UIImage(data: data)
                    images.append(image!)
                }
            }
        }
        
        return images
    }
}