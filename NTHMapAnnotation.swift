//
//  NTHMapAnnotation.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import MapKit

class NTHMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String!
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
    func viewForAnnotation() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "MapCellAnnotationView")
        view.enabled = false
        view.canShowCallout = false
        view.image = UIImage(named: "pin-normal")
        return view
    }
}