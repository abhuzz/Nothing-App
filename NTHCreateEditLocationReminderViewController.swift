//
//  NTHCreateEditLocationReminderViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditLocationReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var placesTableView: UITableView!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var regionSlider: UISlider!
    @IBOutlet private weak var minRegionLabel: UILabel!
    @IBOutlet private weak var curRegionLabel: UILabel!
    @IBOutlet private weak var maxRegionLabel: UILabel!
    @IBOutlet private weak var regionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var regionLabel: UILabel!
    
    
    private var places = [Place]()
    
    private enum SegueIdentifier: String {
        case AddNewPlace = "AddNewPlace"
    }
    
    
    var context: NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.placesTableView.registerNib("NTHCenterLabelCell")
        self.placesTableView.registerNib("NTHLeftLabelCell")
        self.places = ModelController().allPlaces(self.context)
    }
    
    private func _configureUIColors() {
        self.placeLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.separator.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.regionSlider.minimumTrackTintColor = UIColor.NTHNavigationBarColor()
        self.minRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.curRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.maxRegionLabel.textColor = UIColor.NTHHeaderTextColor()
        self.regionSegmentedControl.tintColor = UIColor.NTHNavigationBarColor()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.AddNewPlace.rawValue {
            let vc = segue.destinationViewController as! NTHCreateNewPlaceViewController
            vc.context = self.context
            vc.completionBlock = {
                self.places = ModelController().allPlaces(self.context)
                self.placesTableView.reloadData()
            }
        }
    }
    
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == self.places.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.label.text = "+ Add new place"
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            cell.label.text = self.places[indexPath.row].customName
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.places.count {
            /// show place wizard
            self.performSegueWithIdentifier(SegueIdentifier.AddNewPlace.rawValue, sender: nil)
        } else {
            /// do nothing now
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
