//
//  LocationReminder.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(LocationReminder)
class LocationReminder: Reminder {

    @NSManaged var distance: NSNumber
    @NSManaged var onArrive: NSNumber
    @NSManaged var place: Place!
    @NSManaged var useOpenHours: NSNumber
}

extension LocationReminder {
    func TSRegionRepresentation() -> TSRegion {
        var timeRanges = [TSRegionTimeRange]()
        if self.useOpenHours.boolValue && self.place.useOpenHours.boolValue {
            for obj in self.place.openHours {
                let openTimeRange = (obj as! OpenTimeRange)
                let day = TSRegionTimeRange.Weekday(rawValue: openTimeRange.day.rawValue)!
                timeRanges.append(TSRegionTimeRange(day: day, openHourTimeInterval: openTimeRange.openTimeInterval, closeHourTimeInterval: openTimeRange.closeTimeInterval))
            }
        }
        
        return TSRegion(identifier: task.uniqueIdentifier,
            coordinate: self.place.coordinate,
            notifyOnArrive: self.onArrive.boolValue,
            notifyOnLeave: !self.onArrive.boolValue,
            distance: CLLocationDistance(self.distance.floatValue),
            timeRanges: timeRanges,
            useTimeRanges: self.useOpenHours.boolValue && self.place.useOpenHours.boolValue)
    }
}