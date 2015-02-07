//
//  NTHSelectPlaceTableViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 26/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSelectPlaceTableViewController: UITableViewController {
    
    typealias NTHSelectPlaceTableViewControllerSelectionBlock = (place: Place) -> Void
    
    enum SegueIdentifier: String {
        case AddNewPlace = "AddNewPlace"
    }
    
    var selectionBlock: NTHSelectPlaceTableViewControllerSelectionBlock?
    
    private var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        let centerLabelNib = UINib(nibName: "NTHCenterLabelCell", bundle: nil)
        self.tableView.registerNib(centerLabelNib, forCellReuseIdentifier: "NTHCenterLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.places = ModelController().allPlaces()
        self.tableView.reloadData()
    }
    
    @IBAction func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func numberOfCells() -> Int {
        return self.places.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != self.numberOfCells() - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlaceNameCell") as PlaceNameCell
            cell.label.text = self.places[indexPath.row].customName
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as NTHCenterLabelCell
            cell.label.text = String.addANewPlaceString()
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != self.numberOfCells() - 1 {
            self.selectionBlock?(place: self.places[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier(SegueIdentifier.AddNewPlace.rawValue, sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
