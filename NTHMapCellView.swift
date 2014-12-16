//
//  NTHMapCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHMapCellView: UIView, MKMapViewDelegate {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var topSeparator: UIView!
    @IBOutlet private weak var bottomSeparator: UIView!
    @IBOutlet private weak var noPlaceIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        
        self.topSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.bottomSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.backgroundColor = UIColor.NTHWhiteSmokeColor()
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if (self.subviews.count == 0) {
            let nib = UINib(nibName: "NTHMapCellView", bundle: nil)
            let loadedView = nib.instantiateWithOwner(nil, options: nil).first as NTHMapCellView
            
            /// set view as placeholder is set
            loadedView.frame = self.frame
            loadedView.autoresizingMask = self.autoresizingMask
            loadedView.setTranslatesAutoresizingMaskIntoConstraints(self.translatesAutoresizingMaskIntoConstraints())
            
            for constraint in self.constraints() as [NSLayoutConstraint] {
                var firstItem = constraint.firstItem as NTHMapCellView
                if firstItem == self {
                    firstItem = loadedView
                }
                
                var secondItem = constraint.secondItem as NTHMapCellView?
                if secondItem != nil {
                    if secondItem! == self {
                        secondItem = loadedView
                    }
                }
                
                loadedView.addConstraint(NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
            }
            
            return loadedView
        }
        
        return self
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
    
    
    
    /// Mark: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is NTHMapAnnotation) {
            return (annotation as NTHMapAnnotation).viewForAnnotation()
        }
        
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "ReuseIdentifier")
    }
}
