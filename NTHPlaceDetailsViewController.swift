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

class NTHPlaceDetailsViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, NTHCoreDataCloudSyncProtocol {

    @IBOutlet weak var nameTextField: NTHTextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var openHoursTableView: UITableView!
    @IBOutlet private weak var openHoursTableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var assignedTasksTableView: UITableView!
    
    
    private enum SegueIdentifier: String {
        case EditPlace = "EditPlace"
        case ShowTasks = "ShowTasks"
    }
    
    private enum TableView: Int {
        case AssignedTasks, OpenHours
    }
    
    var place: Place!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openHoursTableView.tag = TableView.OpenHours.rawValue
        self.openHoursTableView.registerNib("NTHOpenHoursCell")
        self.openHoursTableView.registerNib("NTHCenterLabelCell")
        
        self.assignedTasksTableView.tag = TableView.AssignedTasks.rawValue
        self.assignedTasksTableView.registerNib("NTHLeftLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NTHCoreDataCloudSync.sharedInstance.addObserver(self)
        self.navigationItem.title = ""
        self._configureView(self.place)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Place"
        NTHCoreDataCloudSync.sharedInstance.removeObserver(self)
    }
    
    private func _configureView(place: Place) {
        self.nameTextField.text = self.place.name
        
        /// update map
        self._updateMapWithCoordinate(self.place.coordinate)
        
        /// refresh tables
        self.openHoursTableView.refreshTableView(self.openHoursTableViewHeight, height: self._openHoursTableViewHeight())
        self.assignedTasksTableView.reloadData()
    }
    
    private func _updateMapWithCoordinate(coordinate: CLLocationCoordinate2D) {
        self.mapView.removeAllAnnotations()
        self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: "", subtitle: ""))
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .EditPlace:
            let vc = segue.destinationViewController as! NTHCreateEditPlaceViewController
            vc.context = self.context
            vc.place = self.place
            vc.mode = NTHCreateEditPlaceViewController.Mode.Edit
//            vc.completionBlock = { context in
//                self.context.save(nil)
//                self.openHoursTableView.reloadData()
//                self._updateMapWithCoordinate(self.place.coordinate)
//            }

        case .ShowTasks:
            let vc = segue.destinationViewController as! NTHTaskListViewController
            vc.place = self.place
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
    
    @IBAction func editPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(SegueIdentifier.EditPlace.rawValue, sender: nil)
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
        switch TableView(rawValue: tableView.tag)! {
        case .AssignedTasks:
            var hasTasks = self.place.associatedTasks.count > 0
            let title = "Associated Tasks (\(self.place.associatedTasks.count))"
            let cell = NTHLeftLabelCell.create(tableView, title: title)
            cell.accessoryType = hasTasks ? .DisclosureIndicator : .None
            return cell
            
        case .OpenHours:
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableView(rawValue: tableView.tag)! {
        case .OpenHours:
            return self._openHoursTableViewCellsNumber()
        case .AssignedTasks:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch TableView(rawValue: tableView.tag)! {
        case .OpenHours:
            return self._openHoursTableViewCellHeight()
        case .AssignedTasks:
            return 50
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch TableView(rawValue: tableView.tag)! {
        case .AssignedTasks:
            self.performSegueWithIdentifier(SegueIdentifier.ShowTasks.rawValue, sender: nil)
        default: return
        }
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
    
    
    /// MARK: NTHCoreDataCloudSyncProtocol
    func persistentStoreDidReceiveChanges() {
        if self.place.deleted {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self._configureView(self.place)
        }
    }
}
