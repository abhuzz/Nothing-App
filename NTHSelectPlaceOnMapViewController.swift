//
//  NTHAddNewPlaceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 26/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NTHSelectPlaceOnMapViewController: UIViewController, MKMapViewDelegate {

    enum SegueIdentifier: String {
        case CreatePlace = "CreatePlace"
    }
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var context: NSManagedObjectContext!
    
    @IBAction func handleTapOnMap(sender: UITapGestureRecognizer) {
        /// Execute only when gesture is ended
        if (sender.state != UIGestureRecognizerState.Ended) { return }
        
        /// Remove previous annotation
        self.mapView.removeAllAnnotations()
        
        /// Get coordinates
        let touchPoint = sender.locationInView(self.mapView)
        let coordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        /// Create annotation
        CLGeocoder.infoForCoordinate(coordinate, completion: { (info) -> Void in
            let annotation = NTHAnnotation(coordinate: coordinate, title: info)
            self.mapView.addAnnotation(annotation)
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.CreatePlace.rawValue) {
            /// Show create place view
            let createPlaceVC = segue.destinationViewController as! NTHCreatePlaceViewController
            createPlaceVC.context = self.context
            createPlaceVC.annotation = self.mapView.annotations.first as! NTHAnnotation
        }
    }
    
    
    /** 
    MapKit
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return (annotation as! NTHAnnotation).viewForAnnotation()
    }
}

extension MKMapView {
    func removeAllAnnotations() {
        if let annotations = self.annotations {
            self.removeAnnotations(annotations)
        }
    }
}

extension CLGeocoder {
    class func infoForCoordinate(coordinate: CLLocationCoordinate2D, completion: (info: String) -> Void) {
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemark: CLPlacemark = placemarks.last as? CLPlacemark {
                completion(info: placemark.name)
            } else {
                completion(info: "Selected Place");
            }
        })
    }
}
