//
//  NTHSimpleSelectPlceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHSimpleSelectPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    
    private var selectedIndexPath: NSIndexPath?
    
    
    var context: NSManagedObjectContext!
    var reminder: LocationReminderInfo!
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib("NTHCenterLabelCell")
        self.tableView.registerNib("NTHLeftLabelCell")
        self.places = ModelController().allPlaces(self.context)
    }
    
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.places.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = "No place to select."
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let place = self.places[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            
            cell.label.text = place.name
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.leadingConstraint.constant = 15
            
            if let reminderPlace = self.reminder.place {
                if reminderPlace == place {
                    self.selectedIndexPath = indexPath
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        /// deselect old cell
        if let previousIndexPath = self.selectedIndexPath {
            let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! NTHLeftLabelCell
            previousCell.accessoryType = .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            self.selectedIndexPath = indexPath
            self.reminder.place = self.places[indexPath.row]
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            cell.accessoryType = .None
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
