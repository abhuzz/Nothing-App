//
//  MapCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 20/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class MapCellAnnotation: NSObject, MKAnnotation {
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

class MapCell: UITableViewCell, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            if let annotation: MKAnnotation = self.mapView.annotations.first as? MKAnnotation {
                self.mapView.removeAnnotation(annotation)
            }
            
            if let coordinate = self.coordinate {
                self.mapView.addAnnotation(MapCellAnnotation(coordinate: coordinate, title: "Annotation"))
                
                let adjustedRegion = self.mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(coordinate, 1000, 500))
                self.mapView .setRegion(adjustedRegion, animated: true)
            }
        }
    }
    
    /// Mark: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MapCellAnnotation) {
            return (annotation as MapCellAnnotation).viewForAnnotation()
        }
        
        return nil
    }
}
