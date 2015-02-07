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
        
        if let reminder = self.task.locationReminder {
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
        
        if let reminder = self.task.dateReminder {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/YYYY HH:mm"
            self.dateReminderControl.setFirstDetailText(formatter.stringFromDate(reminder.fireDate))
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
}

extension UIAlertController {
    class func actionsForContactActionSheet(contact: Contact) -> UIAlertController {
        let alert = UIAlertController(title: contact.name, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if let phone = contact.phone {
            let action = UIAlertAction(title: String.callString(), style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:"+phone)!)
                return
            })
            alert.addAction(action)
        }
        
        if let email = contact.email {
            let action = UIAlertAction(title: String.sendEmailString(), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:"+email)!)
                return
            })
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: String.cancelString(), style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        
        return alert
    }
    
    class func actionsForPlaceActionSheet(place: Place) -> UIAlertController {
        let alert = UIAlertController(title: place.customName, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let showOnMap = UIAlertAction(title: String.showOnMapString(), style: UIAlertActionStyle.Default) { (action) -> Void in
            let placemark = MKPlacemark(coordinate: place.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            mapItem.openInMapsWithLaunchOptions(options)
        }
        alert.addAction(showOnMap)
        
        let cancel = UIAlertAction(title: String.cancelString(), style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        
        return alert
    }
}
