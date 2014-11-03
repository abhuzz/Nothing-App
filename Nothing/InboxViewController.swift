//
//  InboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreLocation

class InboxViewController: UITableViewController {
    
    private var modelCache = TaskCellVMCache()
    private var tasks: [Task] = [Task]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    enum Identifiers: String {
        case TaskCell = "TaskCell"
    }
    
    enum SegueIdentifier: String {
        case Search = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(TaskCell.nib(), forCellReuseIdentifier: Identifiers.TaskCell.rawValue)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.searchDisplayController?.searchResultsTableView.registerNib(TaskCell.nib(), forCellReuseIdentifier: Identifiers.TaskCell.rawValue)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tasks = ModelController().allTasks()
    }
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        var model = self.modelCache.model(task)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TaskCell.rawValue, forIndexPath: indexPath) as TaskCell
        if model == nil {
            model = TaskCellVM(task)
            self.modelCache.add(model!)
        }
        
        cell.update(model!)
        cell.hashtagSelectedBlock = { hashtag in
            dispatch_async(dispatch_get_main_queue(), { [self]
                self.performSegueWithIdentifier(SegueIdentifier.Search.rawValue, sender: hashtag)
            })
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let task = self.tasks[indexPath.row]
        
        var model = self.modelCache.model(task)
        if (model == nil) {
            model = TaskCellVM(task)
            self.modelCache.add(model!)
        }
        
        let cell = TaskCell.nib().instantiateWithOwner(nil, options: nil).first as TaskCell
        var frame = cell.frame
        frame.size.width = tableView.bounds.width
        cell.frame = frame
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        cell.update(model!)
        return cell.estimatedHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier! == SegueIdentifier.Search.rawValue {
            let vc = segue.destinationViewController as SearchViewController
            
            if sender != nil {
                vc.searchBarText = sender as String
            }
            
            vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
    }

    @IBAction func searchPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(SegueIdentifier.Search.rawValue, sender: nil)
    }
}

