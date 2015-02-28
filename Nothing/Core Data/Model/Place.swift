//
//  Place.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreLocation

@objc(Place)
class Place: Link {
    @NSManaged var name: String!
    @NSManaged private var latitude: NSNumber
    @NSManaged private var longitude: NSNumber
    @NSManaged var locationReminderInfos: NSSet
    @NSManaged var openHours: NSOrderedSet
    @NSManaged var useOpenHours: NSNumber
}

extension Place {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.locationReminderInfos = NSSet()
    }
    
    var coordinate: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2DMake( self.latitude.doubleValue, self.longitude.doubleValue) }
        set {
            self.latitude = NSNumber(double: newValue.latitude)
            self.longitude = NSNumber(double: newValue.longitude)
        }
    }
}
