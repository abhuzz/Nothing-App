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
    
    var useTimeRanges: Bool = false
    var timeRanges = [TSRegionTimeRange]()
    
    init(identifier: String!, coordinate: CLLocationCoordinate2D!, notifyOnArrive: Bool!, notifyOnLeave: Bool!, distance: CLLocationDistance!, timeRanges: [TSRegionTimeRange], useTimeRanges: Bool) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.notifyOnArrive = notifyOnArrive
        self.notifyOnLeave = notifyOnLeave
        self.distance = distance
        self.timeRanges = timeRanges
        self.useTimeRanges = useTimeRanges
    }
    
    func updateRegion(region: TSRegion) {
        self.coordinate = region.coordinate
        self.notifyOnArrive = region.notifyOnArrive
        self.notifyOnLeave = region.notifyOnLeave
        self.distance = region.distance
        self.timeRanges = region.timeRanges
        self.useTimeRanges = region.useTimeRanges
    }
}