//
//  NTHCreateTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateTaskController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    class TaskInfo {
        class LocationReminder {
            var place: Place?
            var distance: Float?
            var onArrive: Bool?
        }
        
        class DateReminder {
            var fireData: NSDate!
            var repeatInterval: NSCalendarUnit!
        }
        
        var dateReminder = DateReminder()
        var locationReminder = LocationReminder()
        var connections = [String]()
    }
    
    enum SegueIdentifier: String {
        case TextEditor = "TextEditor"
        case Places = "Places"
        case Region = "Region"
        case Date = "Date"
        case RepeatInterval = "RepeatInterval"
    }
    
    @IBOutlet weak var titleTextLabel: LabelContainer!
    @IBOutlet weak var descriptionTextLabel: LabelContainer!
    @IBOutlet weak var locationLabel: LabelContainer!
    @IBOutlet weak var regionLabel: LabelContainer!
    @IBOutlet weak var dateLabel: LabelContainer!
    @IBOutlet weak var repeatLabel: LabelContainer!
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var connectionTableViewHeight: NSLayoutConstraint!
    
    private var taskInfo = TaskInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let showTextEditor = {(label: LabelContainer) -> () in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: label)
        }
        
        self.titleTextLabel.placeholder = "What's in your mind?"
        self.titleTextLabel.tapBlock = { [unowned self] in
            showTextEditor(self.titleTextLabel)
        }
        
        self.descriptionTextLabel.placeholder = "Describe this task"
        self.descriptionTextLabel.tapBlock = { [unowned self] in
            showTextEditor(self.descriptionTextLabel)
        }
        
        self.locationLabel.placeholder = "None"
        self.locationLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Places.rawValue, sender: self.locationLabel)
        }
        
        self.regionLabel.placeholder = "None"
        self.regionLabel.enabled = false
        self.regionLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Region.rawValue, sender: self.regionLabel)
        }
        
        self.dateLabel.placeholder = "None"
        self.dateLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Date.rawValue, sender: self.dateLabel)
        }
        
        self.repeatLabel.placeholder = "None"
        self.repeatLabel.enabled = false
        self.repeatLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.RepeatInterval.rawValue, sender: self.repeatLabel)
        }
        
        
        /// setup connections table view
        self.connectionTableView.tableFooterView = UIView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.TextEditor.rawValue) {
            let editorVC = (segue.destinationViewController as UINavigationController).topViewController as TextEditorController
            editorVC.title = "Text Editor"

            let label = (sender as LabelContainer)
            editorVC.text = label.isSet ? label.text : ""
            editorVC.confirmBlock = { text in
                (sender as LabelContainer).text = text
            }
        } else if (segue.identifier == SegueIdentifier.Places.rawValue) {
            let placesVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectPlaceTableViewController
            placesVC.selectionBlock = { [unowned self] (place: Place) in
                self.taskInfo.locationReminder.place = place
                self.locationLabel.text = place.customName
                self.regionLabel.enabled = true
            }
        } else if (segue.identifier == SegueIdentifier.Region.rawValue) {
            let regionVC = segue.destinationViewController as NTHRegionViewController
            regionVC.successBlock = { (distance: Float, onArrive: Bool) in
                let label = (sender as LabelContainer)
                label.text = (onArrive ? "Arrive" : "Leave") + ", " + distance.distanceDescription()
                
                self.taskInfo.locationReminder.distance = distance
                self.taskInfo.locationReminder.onArrive = onArrive
            }
        } else if (segue.identifier == SegueIdentifier.Date.rawValue) {
            let dateVC = segue.destinationViewController as NTHDatePickerViewController
            dateVC.block = { [unowned self] date in
                self.dateLabel.text = NSString(format: "%@", date)
                self.repeatLabel.enabled = true
            }
        } else if (segue.identifier == SegueIdentifier.RepeatInterval.rawValue) {
            let regionVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectRepeatIntervalViewController
            regionVC.completionBlock = { unit, description in
                let label = (sender as LabelContainer)
                label.text = description
                self.taskInfo.dateReminder.repeatInterval = unit
            }
        }
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
            cell.label.text = self.taskInfo.connections[indexPath.row]
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
            let number = self.numberOfItemsInConnectionTableView()
            let text = String(number)
            self.taskInfo.connections.append(text)
            tableView.reloadData()
            
            /// Update table view height
            let height = CGFloat(self.numberOfItemsInConnectionTableView()) * self.heightOfConnectionTableViewCell()
            self.connectionTableViewHeight.constant = height
            
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                self.view.needsUpdateConstraints()
                self.view.updateConstraintsIfNeeded()
                return /// explicit return
            })
        }
    }
}
