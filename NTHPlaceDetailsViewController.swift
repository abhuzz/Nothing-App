//
//  NTHPlaceDetailsViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 14/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NTHPlaceDetailsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameTextField: NTHTextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var openHoursTableView: UITableView!
    @IBOutlet private weak var openHoursTableViewHeight: NSLayoutConstraint!
    
    
    private enum SegueIdentifier: String {
        case EditPlace = "EditPlace"
    }
    
    var place: Place!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openHoursTableView.registerNib("NTHOpenHoursCell")
        self.openHoursTableView.registerNib("NTHCenterLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = ""
        self.nameTextField.text = self.place.name
        /// update map
        self._updateMapWithCoordinate(self.place.coordinate)
        self.openHoursTableView.refreshTableView(self.openHoursTableViewHeight, height: self._openHoursTableViewHeight())
    }
    
    private func _updateMapWithCoordinate(coordinate: CLLocationCoordinate2D) {
        self.mapView.removeAllAnnotations()
        self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: "", subtitle: ""))
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.EditPlace.rawValue {
            let vc = segue.topOfNavigationController as! NTHCreateEditPlaceViewController
            vc.context = CDHelper.temporaryContextWithParent(self.context)
            
            /// Get `place` object but in new contextś
            let placeInTemporaryContext = vc.context.objectWithID(self.place.objectID) as! Place
            vc.place = placeInTemporaryContext
            vc.presentedModally = true
            vc.editingPlace = true
            vc.completionBlock = { context in
                self.context.save(nil)
                self.openHoursTableView.reloadData()
                self._updateMapWithCoordinate(self.place.coordinate)
                /// Notify TSRegionManager that place changed
                NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.ApplicationDidUpdatePlaceSettingsNotification, object: nil)
            }
        }
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete \"\(self.place.name)\"?", preferredStyle: UIAlertControllerStyle.Alert)
        
        /// YES
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
            self.place.removeAllAssociatedObjects(self.context)
            self.context.deleteObject(self.place)
            self.context.save(nil)
            self.context.parentContext?.save(nil)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        /// NO
        alert.addAction(UIAlertAction.cancelAction("No", handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func _sortedOpenHours() -> [OpenTimeRange] {
        return sorted(self.place.openHours.array as! [OpenTimeRange]) { range1, range2 in
            if range1.day == .Sunday {
                return false
            } else if range2.day == .Sunday {
                return true
            }
            
            return range1.day.rawValue < range2.day.rawValue
        }
    }
    
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.place.useOpenHours.boolValue {
            let openHour = self._sortedOpenHours()[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHOpenHoursCell") as! NTHOpenHoursCell
            cell.selectedBackgroundView = UIView()
            
            cell.dayNameLabel.text = openHour.dayString.uppercaseString
            let openHourString = NTHTime(interval: openHour.openTimeInterval).toString()
            let closeHourString = NTHTime(interval: openHour.closeTimeInterval).toString()
            cell.hourLabel.text =  openHourString + " - " + closeHourString
            cell.closedLabel.text = "Closed"
            cell.update(openHour.closed)
            cell.clockButton.hidden = true
            cell.closeButton.hidden = true
            return cell
        } else {
            return NTHCenterLabelCell.create(tableView, title: "Open hours disabled")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self._openHoursTableViewCellsNumber()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self._openHoursTableViewCellHeight()
    }
    
    
    // Table View helpers
    private func _openHoursTableViewCellsNumber() -> Int {
        return self.place.useOpenHours.boolValue ? self.place.openHours.count : 1
    }
    
    private func _openHoursTableViewCellHeight() -> CGFloat {
        return self.place.useOpenHours.boolValue ? 60 : 50
    }
    
    private func _openHoursTableViewHeight() -> CGFloat {
        return self._openHoursTableViewCellHeight() * CGFloat(self._openHoursTableViewCellsNumber())
    }
    
    
    
    /// Mark: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        return (annotation as! NTHAnnotation).viewForAnnotation()
    }
}
