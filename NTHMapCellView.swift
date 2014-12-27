//
//  NTHMapCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHMapCellView: NTHBaseCellView, MKMapViewDelegate {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var noPlaceIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
    }
    
    override func nibName() -> String {
        return "NTHMapCellView"
    }
    
    func mapHidden(hidden: Bool) {
        self.mapView.hidden = hidden
        self.noPlaceIconView.hidden = !hidden
    }
    
    func displayAnnotationPointWithCoordinate(coordinate: CLLocationCoordinate2D) {
        self.mapView.addAnnotation(NTHMapAnnotation(coordinate: coordinate, title: "Point"))
        
        let adjustedRegion = self.mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(coordinate, 1000, 500))
        self.mapView .setRegion(adjustedRegion, animated: true)
    }
    
    
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is NTHMapAnnotation) {
            return (annotation as NTHMapAnnotation).viewForAnnotation()
        }
        
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "ReuseIdentifier")
    }
}
