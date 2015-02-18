//
//  NTHInboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 18/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet private weak var tableView: UITableView!
    
    private var tasks = [Task]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib("NTHInboxCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tasks = ModelController().allTasks()
        self.tableView.reloadData()
    }
    
    /// Mark: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell") as! NTHInboxCell
        cell.update(self.tasks[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
}
