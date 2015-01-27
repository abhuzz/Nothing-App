//
//  NTHAnnotation.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import MapKit

/**
Class represents annotation added to map
*/
class NTHAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String = "") {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    func viewForAnnotation() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "NTHAnnotationView")
        view.enabled = true
        view.canShowCallout = false
        view.image = UIImage(named: "pin-normal")
        return view
    }
}