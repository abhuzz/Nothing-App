//
//  CLLocation_TS.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//


import Foundation
import CoreLocation

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
