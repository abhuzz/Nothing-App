//
//  RegionManager.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class RegionManager {
    
    func processLocation(location: CLLocation) {
        println("processing \(location.coordinate.latitude) \(location.coordinate.longitude).")
        
        var matchingTasks = [Task]()
        
        /// Filter tasks
        let allTasks = ModelController().allTasks()
        for task in allTasks {
            /// Get tasks that has location reminder set
            if let info = task.locationReminderInfo {
                /// Calculate distance to the point
                let taskLocation = CLLocation(coordinate: info.place.coordinate)
                let distance = location.distanceFromLocation(taskLocation)
                
                println("Checking [\(task.title)][\(info.place.coordinate.latitude), \(info.place.coordinate.longitude)][\(info.distance)][\(info.onArrive)] -> [\(distance)]")
                
                /// Check if distance matches rules
                if ((info.onArrive && distance < CLLocationDistance(info.distance)) ||
                    (!info.onArrive && distance > CLLocationDistance(info.distance))) {
                    matchingTasks.append(task)
                }
            }
        }
        
        /// Filtered tasks
        if matchingTasks.count == 0 {
            println("No tasks in close distance.")
            return
        }
        
        for task in matchingTasks {
            println("[\(task.title)] is in distance")
        }
    }
}