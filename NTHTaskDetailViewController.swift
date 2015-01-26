//
//  NTHTaskDetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHTaskDetailViewController: UIViewController, NTHConnectionsCellViewDelegate {
    
    /// views
    @IBOutlet private weak var mapCell: NTHMapCellView!
    @IBOutlet private weak var titleCell: NTHSimpleCellView!
    @IBOutlet private weak var descriptionCell: NTHSimpleCellView!
    @IBOutlet private weak var statusCell: NTHStateCellView!
    @IBOutlet private weak var remindMeAtLocationCell: NTHSimpleCellView!
    @IBOutlet private weak var distanceCell: NTHSimpleCellView!
    @IBOutlet private weak var remindMeOnDateCell: NTHSimpleCellView!
    @IBOutlet private weak var repeatCell: NTHSimpleCellView!
    @IBOutlet private weak var connectionsCell: NTHConnectionsCellView!

    /// public
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        self.updateWithModel(NTHTaskDisplayable(task: self.task))
    }
    
    private func setupCells() {
        self.titleCell.setTitle(NSLocalizedString("Title", comment: ""))
        self.descriptionCell.setTitle(NSLocalizedString("Description", comment: ""))
        self.statusCell.setTitle(NSLocalizedString("Status", comment: ""))
        self.remindMeAtLocationCell.setTitle(NSLocalizedString("Remind me at location", comment: ""))
        self.distanceCell.setTitle(NSLocalizedString("Distance", comment: ""))
        self.remindMeOnDateCell.setTitle(NSLocalizedString("Remind me on date", comment: ""))
        self.repeatCell.setTitle(NSLocalizedString("Repeat", comment: ""))
        self.connectionsCell.setTitle(NSLocalizedString("Connections", comment: ""))
        self.connectionsCell.delegate = self
    }
    
    private func updateWithModel(displayable: NTHTaskDisplayable) {
        let noneString = NSLocalizedString("None", comment: "")
        let notSelectedString = NSLocalizedString("Not selected", comment: "")

        self.title = displayable.taskTitle
        
        /// title
        self.titleCell.setDetail(displayable.taskTitle)
        
        /// description
        self.descriptionCell.setDetail(displayable.taskDescription ?? noneString)
        self.descriptionCell.setEnabled(displayable.taskDescription != nil ? true : false)
        
        /// detail
        self.statusCell.setDetail(displayable.taskStateDescription)
        self.statusCell.statusView.state = displayable.task.state
        
        /// location
        self.remindMeAtLocationCell.setDetail(displayable.nameOfLocationInReminder ?? notSelectedString)
        self.remindMeAtLocationCell.setEnabled(displayable.nameOfLocationInReminder != nil)
        
        /// distance
        self.distanceCell.setDetail(displayable.distanceString ?? notSelectedString)
        self.distanceCell.setEnabled(displayable.distanceString != nil ? true : false)
        
        /// date
        self.remindMeOnDateCell.setDetail(displayable.dateStringInReminder ?? notSelectedString)
        self.remindMeOnDateCell.setEnabled(displayable.dateStringInReminder != nil ? true : false)

        /// repeat interval
        self.repeatCell.setDetail(displayable.repeatString ?? notSelectedString)
        self.repeatCell.setEnabled(displayable.repeatString != nil ? true : false)
        
        /// map
        if let reminder = displayable.task.locationReminder {
            self.mapCell.mapHidden(false)
            self.mapCell.displayAnnotationPointWithCoordinate(reminder.place.coordinate)
        } else {
            self.mapCell.mapHidden(true)
        }
        
        self.connectionsCell.setConnections(self.task.allConnections.allObjects as [Connection])
    }
    
    @IBAction func actionPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: self.task.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// edit
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: UIAlertActionStyle.Default, handler: { [unowned self] (action) -> Void in
            self .performSegueWithIdentifier("EditTaskController", sender: self.task)
        }))
        
        /// mark as...
        if (self.task.state == Task.State.Active) {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Mark as Done", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                /// mark as done
            }))
        } else {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Mark as Active", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                /// mark as active
            }))
        }
        
        /// show place on map
        if let locationReminder = self.task.locationReminder {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Show place on map", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let placemark = MKPlacemark(coordinate: locationReminder.place.coordinate, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = locationReminder.place.customName
                    mapItem.openInMapsWithLaunchOptions(nil)
                })
            }))
        }
        
        /// cancel
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    /// Mark: NTHConnectionsCellViewDelegate
    func connectionsCell(cell: NTHConnectionsCellView, didSelectConnection connection: Connection) {
        /// get some name
        var name = ""
        if (connection is Contact) {
            name = (connection as Contact).name
        } else if (connection is Place) {
            name = (connection as Place).customName
        }
        
        /// create controller
        let controller = UIAlertController(title: name, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// add actions for connections
        let showDetails = UIAlertAction(title: "Show details", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        
        /// cancel
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        controller.addAction(showDetails)
        controller.addAction(cancel)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTaskController" {
            let vc = segue.destinationViewController as NTHEditTaskController
            vc.task = sender as Task
            vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        }
    }
}
