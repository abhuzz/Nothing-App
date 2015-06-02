//
//  NTHSimpleSelectPlceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

enum LinkType {
    case Place
    case Contact
}

class NTHSimpleSelectLinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    var singleSelection = true
    var selectedLinks = [Link]()
    var selectedIndexPaths = [NSIndexPath]()
    
    var linkType: LinkType!
    var links = [Link]()
    var selectedBlock: ((links: [Link]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.linkType == .Place {
            self.title = "Place"
        } else if (self.linkType == .Contact) {
            self.title = "Contact"
        }
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib("NTHCenterLabelCell")
        self.tableView.registerNib("NTHLeftLabelCell")
    }
    
    
    /// Mark: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, self.links.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.links.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            if self.linkType == .Place {
                cell.label.text = "No place to select."
            } else if self.linkType == .Contact {
                cell.label.text = "No contact to select."
            }
            cell.label.font = UIFont.NTHAddNewCellFont()
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let link = self.links[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelCell") as! NTHLeftLabelCell
            
            if link is Place {
                cell.label.text = (link as! Place).name
            } else if link is Contact {
                cell.label.text = (link as! Contact).name
            }
            
            cell.selectedBackgroundView = UIView()
            cell.tintColor = UIColor.NTHNavigationBarColor()
            cell.label.font = UIFont.NTHNormalTextFont()
            cell.leadingConstraint.constant = 15
            
            for selectedLink in self.selectedLinks {
                if selectedLink == link {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    if find(self.selectedIndexPaths, indexPath) == nil {
                        self.selectedIndexPaths.append(indexPath)
                    }
                    break
                }
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if self.links.count == 0 {
            return
        }
        
        let linkToAdd = self.links[indexPath.row]
        
        /// Deselect previous index path
        if (self.singleSelection && self.selectedIndexPaths.count > 0) {
            let cell = tableView.cellForRowAtIndexPath(self.selectedIndexPaths.first!) as! NTHLeftLabelCell
            cell.accessoryType = .None
            self.selectedIndexPaths.removeAtIndex(0)
            self.selectedLinks.removeAtIndex(0)
        }

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            self.selectedLinks.append(linkToAdd)
            self.selectedIndexPaths.append(indexPath)
        } else {
            cell.accessoryType = .None
            if !self.singleSelection {
                let indexToRemove = find(self.selectedIndexPaths, indexPath)
                if let indexToRemove = indexToRemove {
                    self.selectedIndexPaths.removeAtIndex(indexToRemove)
                    self.selectedLinks.removeAtIndex(indexToRemove)
                }
            }
        }
        
        self.selectedBlock?(links: self.selectedLinks)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
