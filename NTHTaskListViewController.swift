//
//  NTHTaskListViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 14/03/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!

    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib("NTHInboxCell")
        self.tableView.registerNib("NTHCenterLabelCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    /// Mark: UITableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.place.associatedTasks.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell") as! NTHInboxCell
            cell.update(self.place.associatedTasks[indexPath.row])
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            return NTHCenterLabelCell.create(tableView, title: "No associated tasks")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NTHTaskDetailsViewController") as! NTHTaskDetailsViewController
        vc.context = self.place.managedObjectContext
        vc.task = self.place.associatedTasks[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, self.place.associatedTasks.count)
    }
}
