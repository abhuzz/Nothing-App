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
    
    
    private var selectedIndexPath: NSIndexPath?
    
    
    var linkType: LinkType!
    var links = [Link]()
    var context: NSManagedObjectContext!
    var selectedLink: Link?
    var completionBlock: ((selected: Link) -> Void)?
    
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
            
            if let selectedLink = self.selectedLink {
                if selectedLink == link {
                    self.selectedIndexPath = indexPath
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
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
        
        /// deselect old cell
        if let previousIndexPath = self.selectedIndexPath {
            let previousCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! NTHLeftLabelCell
            previousCell.accessoryType = .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NTHLeftLabelCell
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            self.selectedIndexPath = indexPath
            
            self.completionBlock?(selected: self.links[indexPath.row])
            
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
