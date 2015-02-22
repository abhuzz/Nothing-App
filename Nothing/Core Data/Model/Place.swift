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
    @NSManaged var originalName: String
    @NSManaged private var customNameString: String?
    @NSManaged private var latitude: NSNumber
    @NSManaged private var longitude: NSNumber
    @NSManaged var locationReminderInfos: NSSet
}

extension Place {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.locationReminderInfos = NSSet()
    }
    
    var customName: String {
        get { return self.customNameString ?? self.originalName }
        set { self.customNameString = newValue }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2DMake( self.latitude.doubleValue, self.longitude.doubleValue) }
        set {
            self.latitude = NSNumber(double: newValue.latitude)
            self.longitude = NSNumber(double: newValue.longitude)
        }
    }
}
