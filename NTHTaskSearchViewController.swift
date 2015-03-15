//
//  NTHTaskSearchViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHTaskSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var navigationBarContainer: UIView!
    @IBOutlet private weak var navigationBarContainerTop: NSLayoutConstraint!
    @IBOutlet private weak var navigationBarContainerHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var context = CDHelper.mainContext
    var results = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.becomeFirstResponder()
        self.tableView.registerNib("NTHCenterLabelCell")
        self.tableView.registerNib("NTHInboxCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    /// Mark: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.results.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell") as! NTHInboxCell
            cell.update(self.results[indexPath.row])
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            return NTHCenterLabelCell.create(tableView, title: "No matching tasks")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NTHTaskDetailsViewController") as! NTHTaskDetailsViewController
        vc.context = self.context
        vc.task = self.results[indexPath.row]
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, self.results.count)
    }

    
    
    /// Mark: UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let allTasks = ModelController().allTasks()
        var tasks = [Task]()
        
        let regexp = NSRegularExpression(pattern: searchText, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
        
        for task in allTasks {
           
            /// Create string to search
            var source = task.title
            for reminder in task.locationReminders {
                source = source + reminder.place.name
            }
            
            for link in task.links.allObjects as! [Link] {
                if (link is Place) {
                    source = source + (link as! Place).name
                } else if (link is Contact) {
                    let contact = (link as! Contact)
                    source = source + contact.name + (contact.phone ?? "") + (contact.email ?? "")
                }
            }
            println(source)
            let matchTaskTitle = regexp?.firstMatchInString(source, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, count(source))) != nil
            if matchTaskTitle {
                tasks.append(task)
            }
        }
        
        self.results = tasks
        self.tableView.reloadData()
    }
}
