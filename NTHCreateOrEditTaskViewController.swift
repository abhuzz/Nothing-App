//
//  NTHCreateOrEditTaskViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateOrEditTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHConnectionCellDelegate {

    enum Mode {
        case Create, Edit
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
    @IBOutlet weak var actionButton: UIBarButtonItem!

//    var taskInfo: NTHTaskInfo!
    var task: Task!
    var context: NSManagedObjectContext!
    
    var completionBlock: (() -> Void)?
    var mode: Mode = .Create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.actionButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.validateCreateButton()
    }
    
    private func setup() {
        /// Title
        self.titleControl.setTitleText(String.titleHeaderString())
        self.titleControl.setDetailPlaceholderText(NSLocalizedString("What's in your mind?", comment: ""))
        if countElements(self.task.title) > 0 {
            self.titleControl.setDetailText(self.task.title)
        }
        
        self.titleControl.setOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: self.titleControl)
        }
        
        /// Description
        self.descriptionControl.setTitleText(String.descriptionHeaderString())
        self.descriptionControl.setDetailPlaceholderText(NSLocalizedString("Describe this task", comment: ""))
        self.descriptionControl.setOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: self.descriptionControl)
        }
        
        if self.mode == .Edit {
            self.descriptionControl.setDetailText(self.task.longDescription ?? "")
        }
        
        /// Location reminder
        self.locationReminderControl.setFirstTitleText(String.remindMeAtLocationHeaderString())
        self.locationReminderControl.setFirstPlaceholder(String.noneString())
        self.locationReminderControl.hideButton()
        self.locationReminderControl.onClearTappedBlock = {
            self.task.locationReminderInfo = nil
        }
        self.locationReminderControl.setFirstOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Places.rawValue, sender: self.locationReminderControl)
        }
        
        self.locationReminderControl.setSecondTitleText(String.regionHeaderString())
        self.locationReminderControl.setSecondPlaceholder(String.noneString())
        self.locationReminderControl.secondDetailLabel.enabled = false
        self.locationReminderControl.setSecondOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Region.rawValue, sender: self.locationReminderControl)
        }
        
        if self.mode == .Edit {
            if let reminder = self.task.locationReminderInfo {
                self.locationReminderControl.setFirstDetailText(reminder.place.customName)
                self.updateSecondDetailTextInLocationReminderControl(reminder.distance, onArrive: reminder.onArrive)
                self.locationReminderControl.secondDetailLabel.enabled = true
            }
        }
        
        /// Date reminder
        self.dateReminderControl.setFirstTitleText(String.remindMeOnDateHeaderString())
        self.dateReminderControl.setFirstPlaceholder(String.noneString())
        self.dateReminderControl.hideButton()
        self.dateReminderControl.setFirstOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Date.rawValue, sender: nil)
        }
        
        self.dateReminderControl.setSecondTitleText(String.repeatHeaderString())
        self.dateReminderControl.setSecondPlaceholder(String.noneString())
        self.dateReminderControl.secondDetailLabel.enabled = false
        self.dateReminderControl.setSecondOnTap { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.RepeatInterval.rawValue, sender: nil)
        }
        
        if self.mode == .Edit {
            if let reminder = self.task.dateReminderInfo {
                self.dateReminderControl.setFirstDetailText(NSDateFormatter.NTHStringFromDate(reminder.fireDate))
                self.dateReminderControl.setSecondDetailText(RepeatInterval.descriptionForInterval(interval: reminder.repeatInterval))
                self.dateReminderControl.secondDetailLabel.enabled = true
            }
        }
        
        /// setup connections table view
        
        let connectionCellNib = UINib(nibName: "NTHConnectionCell", bundle: nil)
        self.connectionTableView.registerNib(connectionCellNib, forCellReuseIdentifier: "NTHConnectionCell")
        
        let centerLabelNib = UINib(nibName: "NTHCenterLabelCell", bundle: nil)
        self.connectionTableView.registerNib(centerLabelNib, forCellReuseIdentifier: "NTHCenterLabelCell")

        self.connectionTableView.tableFooterView = UIView()
        
        self.actionButton.title = self.mode == .Create ? "Create" : "Done"
        
        if self.mode == .Edit {
            self.refreshConnectionsTableView()
        }
    }
    
    private func validateCreateButton() {
        let isTitle = countElements(self.task.title) > 0
        self.actionButton.enabled = isTitle
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
                    self.task.title = text
                } else if control == self.descriptionControl {
                    self.task.longDescription = text
                }
                
                self.validateCreateButton()
            }
        } else if (segue.identifier == SegueIdentifier.Places.rawValue) {
            let placesVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectPlaceTableViewController
            placesVC.context = self.context
            placesVC.selectionBlock = { [unowned self] (place: Place) in
                if self.task.locationReminderInfo == nil {
                    self.task.locationReminderInfo = LocationReminderInfo.create(self.context) as LocationReminderInfo
                    self.task.locationReminderInfo!.distance = 100
                    self.task.locationReminderInfo!.onArrive = true
                }
                
                self.task.locationReminderInfo!.place = place
                self.locationReminderControl.setFirstDetailText(place.customName)
                self.updateSecondDetailTextInLocationReminderControl(self.task.locationReminderInfo!.distance, onArrive: self.task.locationReminderInfo!.onArrive)
                self.locationReminderControl.secondDetailLabel.enabled = true
                self.validateCreateButton()
            }
        } else if (segue.identifier == SegueIdentifier.Region.rawValue) {
            let regionVC = segue.destinationViewController as NTHRegionViewController
            if let place = self.task.locationReminderInfo?.place {
                regionVC.configure(self.task.locationReminderInfo!.distance, onArrive: self.task.locationReminderInfo!.onArrive)
            }
            
            regionVC.successBlock = { [unowned self] (distance: Float, onArrive: Bool) in
                self.task.locationReminderInfo!.distance = distance
                self.task.locationReminderInfo!.onArrive = onArrive
                self.updateSecondDetailTextInLocationReminderControl(self.task.locationReminderInfo!.distance, onArrive: self.task.locationReminderInfo!.onArrive)
            }
        } else if (segue.identifier == SegueIdentifier.Date.rawValue) {
            let dateVC = segue.destinationViewController as NTHDatePickerViewController
            if let reminder = self.task.dateReminderInfo {
                dateVC.configure(reminder.fireDate)
            }
            
            dateVC.block = { [unowned self] date in                
                self.dateReminderControl.setFirstDetailText(NSDateFormatter.NTHStringFromDate(date))
                self.dateReminderControl.secondDetailLabel.enabled = true
                
                if self.task.dateReminderInfo == nil {
                    self.task.dateReminderInfo = DateReminderInfo.create(self.context) as DateReminderInfo
                    self.task.dateReminderInfo!.repeatInterval = NSCalendarUnit.allZeros
                }
                
                self.task.dateReminderInfo!.fireDate = date
            }
        } else if (segue.identifier == SegueIdentifier.RepeatInterval.rawValue) {
            let regionVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectRepeatIntervalViewController
                regionVC.completionBlock = { [unowned self] unit, description in
                self.dateReminderControl.setSecondDetailText(description)
                self.task.dateReminderInfo!.repeatInterval = unit
            }
        }
    }
    
    private func updateSecondDetailTextInLocationReminderControl(distance: Float, onArrive: Bool) {
        self.locationReminderControl.setSecondDetailText((onArrive ? String.arriveString() : String.leaveString()) + ", " + distance.distanceDescription())
    }
    
    @IBAction func createPressed(sender: AnyObject) {
        self.context.performBlockAndWait({
            self.context.save(nil)
            CDHelper.mainContext.performBlockAndWait({
                CDHelper.mainContext.save(nil)
                return
            })
            return
        })
        
        self.task.schedule()
        
        self.completionBlock?()
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func numberOfItemsInConnectionTableView() -> Int {
        return self.task.allConnections.allObjects.count + 1
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
            let connection = self.task.allConnections.allObjects[indexPath.row] as Connection
            if connection is Contact {
                cell.label.text = (connection as Contact).name
            } else {
                cell.label.text = (connection as Place).customName
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as NTHCenterLabelCell
            cell.label.text = String.addANewConnectionString()
            return cell
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
                    vc.context = self.context
                    vc.selectionBlock = { [unowned self] contact in
                        self.task.addConnection(contact as Connection)
                        self.refreshConnectionsTableView()
                    }
                    
                    self.presentViewController(nc, animated: true, completion: nil)
                } else if action.identifier == "place" {
                    let nc = UIStoryboard.instantiateNTHSelectPlaceTableViewControllerInNavigationController()
                    let vc = nc.topViewController as NTHSelectPlaceTableViewController
                    vc.context = self.context
                    vc.selectionBlock = { [unowned self] place in
                        self.task.addConnection(place as Connection)
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
            self.task.removeConnection(self.task.allConnections.allObjects[indexPath.row] as? Connection)
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
