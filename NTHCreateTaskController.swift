//
//  NTHCreateTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateTaskController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHConnectionCellDelegate {

    class TaskInfo {
        class LocationReminder {
            var place: Place?
            var distance: Float?
            var onArrive: Bool?
        }
        
        class DateReminder {
            var fireDate: NSDate!
            var repeatInterval: NSCalendarUnit!
        }
        
        var title = ""
        var description = ""
        var dateReminder = DateReminder()
        var locationReminder = LocationReminder()
        var connections = [Connection]()
    }
    
    enum SegueIdentifier: String {
        case TextEditor = "TextEditor"
        case Places = "Places"
        case Region = "Region"
        case Date = "Date"
        case RepeatInterval = "RepeatInterval"
    }
    
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var connectionTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleControl: NTHBasicTitleDetailView!
    @IBOutlet weak var descriptionControl: NTHBasicTitleDetailView!
    @IBOutlet weak var locationReminderControl: NTHDoubleTitleDetailView!
    @IBOutlet weak var dateReminderControl: NTHDoubleTitleDetailView!

    private var taskInfo = TaskInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let showTextEditor = {(label: LabelContainer) -> () in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: label)
        }
        
        /// Title
        self.titleControl.setTitleText(NSLocalizedString("Title", comment: ""))
        self.titleControl.setDetailPlaceholderText(NSLocalizedString("What's in your mind?", comment: ""))
        self.titleControl.setOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: self.titleControl)
        }
        
        /// Description
        self.descriptionControl.setTitleText(NSLocalizedString("Description", comment: ""))
        self.descriptionControl.setDetailPlaceholderText(NSLocalizedString("Describe this task", comment: ""))
        self.descriptionControl.setOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: self.descriptionControl)
        }
        
        /// Location reminder
        self.locationReminderControl.setFirstTitleText(NSLocalizedString("Remind me at location", comment: ""))
        self.locationReminderControl.setFirstPlaceholder(NSLocalizedString("None", comment: ""))
        self.locationReminderControl.hideButton()
        self.locationReminderControl.onClearTappedBlock = {
            self.taskInfo.locationReminder.place = nil
            self.taskInfo.locationReminder.distance = 0
            self.taskInfo.locationReminder.onArrive = true
        }
        self.locationReminderControl.setFirstOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Places.rawValue, sender: self.locationReminderControl)
        }
        
        self.locationReminderControl.setSecondTitleText(NSLocalizedString("Region", comment: ""))
        self.locationReminderControl.setSecondPlaceholder(NSLocalizedString("None", comment: ""))
        self.locationReminderControl.secondDetailLabel.enabled = false
        self.locationReminderControl.setSecondOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Region.rawValue, sender: self.locationReminderControl)
        }
        
        /// Date reminder
        self.dateReminderControl.setFirstTitleText(NSLocalizedString("Remind me on date", comment: ""))
        self.dateReminderControl.setFirstPlaceholder(NSLocalizedString("None", comment: ""))
        self.dateReminderControl.hideButton()
        self.dateReminderControl.setFirstOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Date.rawValue, sender: nil)
        }
        
        self.dateReminderControl.setSecondTitleText(NSLocalizedString("Repeat", comment: ""))
        self.dateReminderControl.setSecondPlaceholder(NSLocalizedString("None", comment: ""))
        self.dateReminderControl.secondDetailLabel.enabled = false
        self.dateReminderControl.setSecondOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.RepeatInterval.rawValue, sender: nil)
        }
        
        /// setup connections table view
        self.connectionTableView.tableFooterView = UIView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.TextEditor.rawValue) {
            let editorVC = (segue.destinationViewController as UINavigationController).topViewController as NTHTextEditorViewController
            editorVC.title = "Text Editor"
            
            let control = sender as NTHBasicTitleDetailView
            editorVC.text = control.isSet ? control.detailLabel.text : ""
            editorVC.confirmBlock = { [unowned self] text in
                control.setDetailText(text)
                if control == self.titleControl {
                    self.taskInfo.title = text
                } else if control == self.descriptionControl {
                    self.taskInfo.description = text
                }
            }
        } else if (segue.identifier == SegueIdentifier.Places.rawValue) {
            let placesVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectPlaceTableViewController
            placesVC.selectionBlock = { [unowned self] (place: Place) in
                self.taskInfo.locationReminder.place = place
                self.taskInfo.locationReminder.onArrive = true
                self.taskInfo.locationReminder.distance = 100
                self.locationReminderControl.setFirstDetailText(place.customName)
                self.updateSecondDetailTextInLocationReminderControl(self.taskInfo.locationReminder.distance!, onArrive: self.taskInfo.locationReminder.onArrive!)
                self.locationReminderControl.secondDetailLabel.enabled = true
            }
        } else if (segue.identifier == SegueIdentifier.Region.rawValue) {
            let regionVC = segue.destinationViewController as NTHRegionViewController
            regionVC.successBlock = { [unowned self] (distance: Float, onArrive: Bool) in
                self.taskInfo.locationReminder.distance = distance
                self.taskInfo.locationReminder.onArrive = onArrive
                self.updateSecondDetailTextInLocationReminderControl(self.taskInfo.locationReminder.distance!, onArrive: self.taskInfo.locationReminder.onArrive!)
            }
        } else if (segue.identifier == SegueIdentifier.Date.rawValue) {
            let dateVC = segue.destinationViewController as NTHDatePickerViewController
            dateVC.block = { [unowned self] date in
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "dd/MM/YYYY HH:mm"
                
                self.dateReminderControl.setFirstDetailText(formatter.stringFromDate(date))
                self.dateReminderControl.secondDetailLabel.enabled = true
                self.taskInfo.dateReminder.fireDate = date
            }
        } else if (segue.identifier == SegueIdentifier.RepeatInterval.rawValue) {
            let regionVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectRepeatIntervalViewController
            regionVC.completionBlock = { [unowned self] unit, description in
                self.dateReminderControl.setSecondDetailText(description)
                self.taskInfo.dateReminder.repeatInterval = unit
            }
        }
    }
    
    private func updateSecondDetailTextInLocationReminderControl(distance: Float, onArrive: Bool) {
        self.locationReminderControl.setSecondDetailText((onArrive ? "Arrive" : "Leave") + ", " + distance.distanceDescription())
    }

    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func numberOfItemsInConnectionTableView() -> Int {
        return self.taskInfo.connections.count + 1
    }
    
    func heightOfConnectionTableViewCell() -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInConnectionTableView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row != self.numberOfItemsInConnectionTableView() - 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHConnectionCell") as NTHConnectionCell
            cell.delegate = self
            let connection = self.taskInfo.connections[indexPath.row]
            if connection is Contact {
                cell.label.text = (connection as Contact).name
            } else {
                cell.label.text = (connection as Place).customName
            }
            
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("NTHAddConnectionCell") as NTHAddConnectionCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.heightOfConnectionTableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.row != self.numberOfItemsInConnectionTableView() - 1) {
            /// Do nothing here
        } else {
            let types = [
                "contact": NSLocalizedString("Contact", comment: ""),
                "place": NSLocalizedString("Place", comment: "")
            ]
            
            let alert = UIAlertController.selectConnectionTypeActionSheet(types, completion: { (action: NTHAlertAction) -> Void in
                if action.identifier == "contact" {
                    let nc = UIStoryboard.instantiateNTHSelectContactViewControllerInNavigationController()
                    let vc = nc.topViewController as NTHSelectContactViewController
                    vc.selectionBlock = { [unowned self] contact in
                        self.taskInfo.connections.append(contact)
                        self.refreshConnectionsTableView()
                    }
                    
                    self.presentViewController(nc, animated: true, completion: nil)
                } else if action.identifier == "place" {
                    let nc = UIStoryboard.instantiateNTHSelectPlaceTableViewControllerInNavigationController()
                    let vc = nc.topViewController as NTHSelectPlaceTableViewController
                    vc.selectionBlock = { [unowned self] place in
                        self.taskInfo.connections.append(place)
                        self.refreshConnectionsTableView()
                    }
                    
                    self.presentViewController(nc, animated: true, completion: nil)
                }
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func refreshConnectionsTableView() {
        /// Update table view height
        let height = CGFloat(self.numberOfItemsInConnectionTableView()) * self.heightOfConnectionTableViewCell()
        self.connectionTableViewHeight.constant = height
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.view.needsUpdateConstraints()
            self.connectionTableView.reloadData()
            return /// explicit return
        })
    }
    
    
    /// Mark: NTHConnectionCellDelegate
    func cellDidTapClearButton(cell: NTHConnectionCell) {
        if let indexPath = self.connectionTableView.indexPathForCell(cell) {
            self.taskInfo.connections.removeAtIndex(indexPath.row)
            self.refreshConnectionsTableView()
        }
    }
}

class NTHAlertAction : UIAlertAction {
    var identifier: String!
}

extension UIAlertController {
    class func selectConnectionTypeActionSheet(types: [String: String], completion:(action: NTHAlertAction) -> Void) -> UIAlertController {
        /// Create alert
        let alert = UIAlertController(title: NSLocalizedString("Connections", comment:""), message: NSLocalizedString("What type of connection do you want to add?", comment:""), preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        /// Fill it with types
        for (identifier, description) in types {
            let action = NTHAlertAction(title: description, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                completion(action: action as NTHAlertAction)
            })
            action.identifier = identifier
            alert.addAction(action)
        }
        
        /// Add cancel
        let action = NTHAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
}

extension UIStoryboard {
    class func instantiateNTHSelectPlaceTableViewControllerInNavigationController() -> UINavigationController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectPlaceNC") as UINavigationController
    }
    
    class func instantiateNTHSelectContactViewControllerInNavigationController() -> UINavigationController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectContactNC") as UINavigationController
    }
}
