//
//  MKMapView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func removeAllAnnotations() {
        if let annotations = self.annotations {
            self.removeAnnotations(annotations)
        }
    }
}