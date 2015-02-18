//
//  NTHSelectPlaceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 17/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHSelectPlaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet private weak var placesTableView: UITableView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!

    
    
    private enum SegueIdentifier: String {
        case AddNewPlace = "AddNewPlace"
    }

    private var selectedIndexPath: NSIndexPath?
    private var places = [Place]()
    
    var context: NSManagedObjectContext!
    var completionBlock: ((selectedPlace: Place!) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placesTableView.registerNib("NTHCenterLabelCell")
        self.placesTableView.registerNib("NTHLeftLabelCell")
        self.places = ModelController().allPlaces(self.context)
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.selectedIndexPath != nil
    }
    
    
    @IBAction func donePressed(sender: AnyObject) {
        self.completionBlock?(selectedPlace: self.places[selectedIndexPath!.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.AddNewPlace.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditPlaceViewController
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
            let place = self.places[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            
            cell.label.text = place.customName
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == self.places.count {
            /// show place wizard
            self.performSegueWithIdentifier(SegueIdentifier.AddNewPlace.rawValue, sender: nil)
        } else {
            /// deselect old cell
            if let previousIndexPath = self.selectedIndexPath {
                let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! NTHLeftLabelCell
                previousCell.accessoryType = .None
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                self.selectedIndexPath = indexPath
            } else {
                cell.accessoryType = .None
            }
        }
        
        self._validateDoneButton()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

}
