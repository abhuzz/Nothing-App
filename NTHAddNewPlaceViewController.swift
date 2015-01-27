//
//  NTHAddNewPlaceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 26/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHAddNewPlaceViewController: UIViewController, MKMapViewDelegate {
    
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
            view.canShowCallout = true
            view.image = UIImage(named: "pin-normal")
            return view
        }
    }
    
    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleTapOnMap(sender: UITapGestureRecognizer) {
        /// Execute only when gesture is ended
        if (sender.state != UIGestureRecognizerState.Ended) { return }
        
        /// Remove previous annotation
        self.mapView.removeAllAnnotations()
        
        /// Get coordinates
        let touchPoint = sender.locationInView(self.mapView)
        let coordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        /// Create annotation
        let annotation = NTHAnnotation(coordinate: coordinate, title: "Place")
        self.mapView.addAnnotation(annotation)
    }
    
    
    /** 
    MapKit
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return (annotation as NTHAnnotation).viewForAnnotation()
    }
}

extension MKMapView {
    func removeAllAnnotations() {
        if let annotations = self.annotations {
            self.removeAnnotations(annotations)
        }
    }
}