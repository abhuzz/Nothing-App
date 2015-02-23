//
//  NTHMapViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 23/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    
    var completionBlock: ((coordinate: CLLocationCoordinate2D) -> Void)?
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.tintColor = UIColor.NTHNavigationBarColor()
        
        if let coordinate = self.coordinate {
            self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: ""))
            self._setRegionForCoordinate(coordinate)
        }
        
        self._validateDoneButton()
    }
    
    @IBAction func locateMePressed(sender: AnyObject) {
        self._setRegionForCoordinate(self.mapView.userLocation.coordinate)
    }
    
    private func _setRegionForCoordinate(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        /// Execute only when gesture is ended
        if (sender.state != UIGestureRecognizerState.Ended) { return }
        
        /// Remove previous annotation
        self.mapView.removeAllAnnotations()
        
        /// Get coordinates
        let touchPoint = sender.locationInView(self.mapView)
        let coordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        /// Create annotation
        self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: ""))
        self._validateDoneButton()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        var annotation: NTHAnnotation!
        for ann in self.mapView.annotations as! [MKAnnotation] {
            if ann is NTHAnnotation {
                annotation = ann as! NTHAnnotation
                break
            }
        }
        
        self.completionBlock?(coordinate: (annotation.coordinate))
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.mapView.annotations.count > 0
    }
    
    /// Mark: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        return (annotation as! NTHAnnotation).viewForAnnotation()
    }
}
