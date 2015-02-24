//
//  NTHInboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 18/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet private weak var tableView: UITableView!
    
    private var resultsController: NSFetchedResultsController!
    
    private enum SegueIdentifier: String {
        case CreateTask = "CreateTask"
        case ShowTask = "ShowTask"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        
        //// create results controller
        self._createResultsController()
        
        /// configure cell
        self.tableView.registerNib("NTHInboxCell")
        self.tableView.tableFooterView = UIView()
    }
    
    private func _createResultsController() {
        let request = NSFetchRequest(entityName: "Task")
        request.predicate = NSPredicate(format: "trashed == 0", argumentArray: nil)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDHelper.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController.performFetch(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let refreshBlock: (task: Task) -> Void = { _ in
            self.resultsController.performFetch(nil)
            self.tableView.reloadData()
        }
        
        if segue.identifier == SegueIdentifier.CreateTask.rawValue {
            let vc = segue.destinationViewController as! NTHCreateEditTaskViewController
            vc.context = CDHelper.temporaryContext
            vc.completionBlock = refreshBlock
        } else if segue.identifier == SegueIdentifier.ShowTask.rawValue {
            let vc = segue.destinationViewController as! NTHTaskDetailsViewController
            vc.context = CDHelper.temporaryContext
            
            /// get task from the temporary context to be able to make operations on it like deleting.
            if let task = sender as? Task {
                var registeredObject = vc.context.objectWithID(task.objectID)
                vc.task = (registeredObject as? Task)!
                vc.completionBlock = {
                    self.resultsController.performFetch(nil)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    /// Mark: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell") as! NTHInboxCell
        cell.update(self.resultsController.fetchedObjects![indexPath.row] as! Task)
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(SegueIdentifier.ShowTask.rawValue, sender: self.resultsController.fetchedObjects![indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
}
