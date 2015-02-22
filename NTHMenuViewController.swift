//
//  NTHMenuViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 22/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet private weak var tableView: UITableView!
    
    private enum MenuOption: String {
        case Places = "Places"
        case Contacts = "Contacts"
    }
    
    private enum SegueIdentifier: String {
        case ShowPlaces = "ShowPlaces"
        case ShowContacts = "ShowContacts"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib("NTHLeftLabelCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.NTHTableViewSeparatorColor()
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ShowPlaces.rawValue {
            let vc = segue.destinationViewController as! NTHSelectPlaceViewController
            vc.context = CDHelper.mainContext
            vc.showDoneButton = false
            vc.canSelectPlace = false
            vc.canEditPlace = true
            vc.saveContextEveryChange = true
        } else if segue.identifier == SegueIdentifier.ShowContacts.rawValue {
            let vc = segue.destinationViewController as! NTHSelectContactViewController
            vc.context = CDHelper.mainContext
            vc.showDoneButton = false
            vc.canSelectContact = false
            vc.canEditContact = true
            vc.saveContextEveryChange = true
        }
    }
    
    
    /// Mark: Table View
    
    private func _options() -> [MenuOption] {
        return [.Places, .Contacts]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._options().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let option = self._options()[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
        cell.label.text = option.rawValue
        cell.leadingConstraint.constant = 15
        cell.selectedBackgroundView = UIView()
//        cell.selectedBackgroundView.backgroundColor = UIColor.NTHNavigationBarColor()
        cell.label.font = UIFont.NTHNormalTextFont()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let option = self._options()[indexPath.row]
        switch option {
        case .Places:
            self.performSegueWithIdentifier(SegueIdentifier.ShowPlaces.rawValue, sender: nil)
            return
            
        case .Contacts:
            self.performSegueWithIdentifier(SegueIdentifier.ShowContacts.rawValue, sender: nil)
            return
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
}
