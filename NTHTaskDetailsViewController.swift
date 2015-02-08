//
//  NTHTaskDetailsViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 05/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class NTHTaskDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum SegueIdentifier: String {
        case EditTask = "EditTask"
    }
    
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var connectionTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleControl: NTHBasicTitleDetailView!
    @IBOutlet weak var descriptionControl: NTHBasicTitleDetailView!
    @IBOutlet weak var locationReminderControl: NTHDoubleTitleDetailView!
    @IBOutlet weak var dateReminderControl: NTHDoubleTitleDetailView!
    @IBOutlet weak var statusView: NTHTaskStatusView!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        
        /// Status view
        self.statusView.state = self.task.state
        
        /// Title
        self.titleControl.setTitleText(String.titleHeaderString())
        self.titleControl.setDetailText(self.task.title)

        /// Description
        self.descriptionControl.setTitleText(String.descriptionHeaderString())
        self.descriptionControl.setDetailPlaceholderText(String.noneString())
        self.descriptionControl.setDetailText(self.task.longDescription ?? "")

        /// Location reminder
        self.locationReminderControl.setFirstTitleText(String.remindMeAtLocationHeaderString())
        self.locationReminderControl.setFirstPlaceholder(String.noneString())
        
        self.locationReminderControl.setSecondTitleText(String.regionHeaderString())
        self.locationReminderControl.setSecondPlaceholder(String.noneString())
        
        if let reminder = self.task.locationReminderInfo {
            self.locationReminderControl.setFirstDetailText(reminder.place.customName)
            let arriveOrLeave = reminder.onArrive ? String.arriveString() : String.leaveString()
            self.locationReminderControl.setSecondDetailText(arriveOrLeave + ", " + reminder.distance.distanceDescription())
        }
        self.locationReminderControl.hideButton()
        
        /// Date reminder
        self.dateReminderControl.setFirstTitleText(String.remindMeOnDateHeaderString())
        self.dateReminderControl.setFirstPlaceholder(String.noneString())
        self.dateReminderControl.hideButton()
        
        self.dateReminderControl.setSecondTitleText(String.repeatHeaderString())
        self.dateReminderControl.setSecondPlaceholder(String.noneString())
        
        if let reminder = self.task.dateReminderInfo {
            self.dateReminderControl.setFirstDetailText(NSDateFormatter.NTHStringFromDate(reminder.fireDate))
            self.dateReminderControl.setSecondDetailText(RepeatInterval.descriptionForInterval(interval: reminder.repeatInterval))
        }
        self.dateReminderControl.hideButton()
        
        /// Connections
        let connectionCellNib = UINib(nibName: "NTHConnectionCell", bundle: nil)
        self.connectionTableView.registerNib(connectionCellNib, forCellReuseIdentifier: "NTHConnectionCell")
        
        let centerLabelNib = UINib(nibName: "NTHCenterLabelCell", bundle: nil)
        self.connectionTableView.registerNib(centerLabelNib, forCellReuseIdentifier: "NTHCenterLabelCell")

        self.connectionTableView.tableFooterView = UIView()
        
        self.refreshConnectionsTableView()
    }
    
    @IBAction func morebuttonPressed(sender: AnyObject!) {
        let alert = UIAlertController.actionsForTaskInDetailViewActionSheet(self.task, presentEditingViewController: {
            self.performSegueWithIdentifier(SegueIdentifier.EditTask.rawValue, sender: nil)
        }, changeState: {
            self.task.changeState()
            self.statusView.state = self.task.state
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func numberOfItemsInConnectionTableView() -> Int {
        return self.task.allConnections.count
    }
    
    func heightOfConnectionTableViewCell() -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.numberOfItemsInConnectionTableView(), 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.numberOfItemsInConnectionTableView() > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHConnectionCell") as NTHConnectionCell
            let connection: Connection = self.task.allConnections.allObjects[indexPath.row] as Connection
            if connection is Contact {
                cell.label.text = (connection as Contact).name
            } else {
                cell.label.text = (connection as Place).customName
            }
            
            cell.hideShowButton(true, animated: false)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as NTHCenterLabelCell
            cell.label.text = String.noConnectionsString()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.heightOfConnectionTableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.numberOfItemsInConnectionTableView() > 0 {
            let connection = self.task.allConnections.allObjects[indexPath.row] as Connection
            if connection is Contact {
                let alert = UIAlertController.actionsForContactActionSheet(connection as Contact)
                self.presentViewController(alert, animated: true, completion: nil)
            } else if connection is Place {
                let alert = UIAlertController.actionsForPlaceActionSheet(connection as Place)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func refreshConnectionsTableView() {
        /// Update table view height
        let height = CGFloat(max(1, self.numberOfItemsInConnectionTableView())) * self.heightOfConnectionTableViewCell()
        self.connectionTableViewHeight.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            self.connectionTableView.reloadData()
            return /// explicit return
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.EditTask.rawValue {
            let editVC = segue.destinationViewController as NTHCreateOrEditTaskViewController
            editVC.mode = NTHCreateOrEditTaskViewController.Mode.Edit
            
            let context = CDHelper.temporaryContext
            editVC.context = context
            let task = context.objectWithID(self.task.objectID) as Task
            editVC.task = task
            editVC.completionBlock = {
                self.setup()
            }
        }
    }
}

extension UIAlertController {
    class func actionsForContactActionSheet(contact: Contact) -> UIAlertController {
        let alert = UIAlertController(title: contact.name, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// Call
        if let phone = contact.phone {
            alert.addAction(UIAlertAction.normalAction(String.callString(), handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:"+phone)!)
                return
            }))
        }
        
        /// Send Email
        if let email = contact.email {
            alert.addAction(UIAlertAction.normalAction(String.sendEmailString(), handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:"+email)!)
                return
            }))
        }
        
        /// Cancel
        alert.addAction(UIAlertAction.cancelAction(String.cancelString(), handler: nil))
        
        return alert
    }
    
    class func actionsForPlaceActionSheet(place: Place) -> UIAlertController {
        let alert = UIAlertController(title: place.customName, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        /// Show on map
        alert.addAction(UIAlertAction.normalAction(String.showOnMapString(), handler: { _ in
            let placemark = MKPlacemark(coordinate: place.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            mapItem.openInMapsWithLaunchOptions(options)
        }))
        
        /// Cancel
        alert.addAction(UIAlertAction.cancelAction(String.cancelString(), handler: nil))
        
        return alert
    }
    
    class func actionsForTaskInDetailViewActionSheet(task: Task, presentEditingViewController: () -> (), changeState: () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: task.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// Edit
        alert.addAction(UIAlertAction.normalAction(String.editString(), handler: { _ in
            presentEditingViewController()
        }))
        
        /// Done or Active
        alert.addAction(UIAlertAction.normalAction((task.state == .Active) ? String.markAsDoneString() : String.markAsActiveString(), handler: { _ in
            changeState()
        }))

        /// Cancel
        alert.addAction(UIAlertAction.cancelAction(String.cancelString(), handler: nil))

        return alert
    }
}
