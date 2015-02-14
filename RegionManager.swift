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

protocol RegionManagerDelegate {
    func regionManager(manager: RegionManager, didSelectRegions regions: [RegionManager.Region])
}

class RegionManager {
    
    class Region {
        let identifier: String
        let coordinate: CLLocationCoordinate2D
        let onArrive: Bool
        let distance: CLLocationDistance
        var valid: Bool = false
        var displayed: Bool = false
        
        init(identifier: String, coordinate: CLLocationCoordinate2D, onArrive: Bool, distance: CLLocationDistance) {
            self.identifier = identifier
            self.onArrive = onArrive
            self.distance = distance
            self.coordinate = coordinate
        }
    }
    
    private var regions = [Region]()
    var delegate: RegionManagerDelegate?
    
    func processLocation(location: CLLocation) {
        println("processing \(location.coordinate.latitude) \(location.coordinate.longitude).")
        
        var matchingTasks = [Task]()
        
        /// Filter tasks
        let allTasks = ModelController().allTasks()
        for task in allTasks {
            /// Get tasks that has location reminder set
            if let info = task.locationReminderInfo {
                
                /// Find if element exists
                var next = false
                for region in regions {
                    if region.identifier == task.uniqueIdentifier {
                        next = true
                        break
                    }
                }
                
                /// Omit this task
                if next {
                    continue
                }
                
                /// Create region and add to the table
                let region = Region(identifier: task.uniqueIdentifier, coordinate: info.place.coordinate, onArrive: info.onArrive, distance: CLLocationDistance(info.distance))
                
                self.regions.append(region)
            }
        }
        
        /// Refresh Regions
        var toShow = [Region]()
        for region in self.regions {
            let diffDistance = location.distanceFromLocation(CLLocation(coordinate: region.coordinate))
            if ((region.onArrive && region.distance > diffDistance) || (!region.onArrive && region.distance < diffDistance)) {
                if region.valid == false {
                    region.valid = true
                    toShow.append(region)
                }
            } else {
                region.valid = false
                region.displayed = false
            }
        }
        
        for region in self.regions {
            if region.valid && !region.displayed {
                region.displayed = true
                println(region.identifier)
            }
        }
        
        /// notify delegate object
        self.delegate?.regionManager(self, didSelectRegions: toShow)
    }
}