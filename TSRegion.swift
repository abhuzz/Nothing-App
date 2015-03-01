//
//  TSRegion.swift
//  Nothing
//
//  Created by Tomasz Szulc on 14/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreLocation

class TSRegion {
    let identifier: String
    var coordinate: CLLocationCoordinate2D
    var notifyOnArrive: Bool
    var notifyOnLeave: Bool
    var distance: CLLocationDistance
    
    var satisfiesOnArrive = false
    var onArriveNotificationSent = false

    var satisfiesOnLeave = false
    var onLeaveNotificationSent = false
    
    var timeRanges = [TSRegionTimeRange]()
    
    init(identifier: String!, coordinate: CLLocationCoordinate2D!, notifyOnArrive: Bool!, notifyOnLeave: Bool!, distance: CLLocationDistance!, timeRanges: [TSRegionTimeRange]) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.notifyOnArrive = notifyOnArrive
        self.notifyOnLeave = notifyOnLeave
        self.distance = distance
        self.timeRanges = timeRanges
    }
    
    func updateRegion(region: TSRegion) {
        if self.coordinate != region.coordinate {
            self.coordinate = region.coordinate
            println("update coordinate")
        }
        
        if self.notifyOnArrive != region.notifyOnArrive {
            self.notifyOnArrive = region.notifyOnArrive
            println("update notifyOnArrive")
        }
        
        if self.notifyOnLeave != region.notifyOnLeave {
            self.notifyOnLeave = region.notifyOnLeave
            println("update notifyOnLeave")
        }
        
        if self.distance != region.distance {
            self.distance = region.distance
            println("distance update")
        }
    }
}