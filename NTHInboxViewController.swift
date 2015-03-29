//
//  NTHInboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 18/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHCoreDataCloudSyncProtocol {

    
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
        self.tableView.registerNib("NTHCenterLabelCell")
        self.tableView.tableFooterView = UIView()
    }
    
    private func _createResultsController() {
        let request = NSFetchRequest(entityName: "Task")
        request.predicate = NSPredicate(format: "trashed == 0", argumentArray: nil)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CDHelper.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController.performFetch(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NTHCoreDataCloudSync.sharedInstance.addObserver(self)
        
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NTHCoreDataCloudSync.sharedInstance.removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let refreshBlock: (task: Task) -> Void = { _ in
            CDHelper.mainContext.save(nil)
            self.resultsController.performFetch(nil)
            self.tableView.reloadData()
        }
        
        if segue.identifier == SegueIdentifier.CreateTask.rawValue {
            let vc = segue.topOfNavigationController as! NTHCreateEditTaskViewController
            vc.context = CDHelper.temporaryContext
            vc.completionBlock = refreshBlock
        } else if segue.identifier == SegueIdentifier.ShowTask.rawValue {
            let vc = segue.destinationViewController as! NTHTaskDetailsViewController
            vc.context = CDHelper.temporaryContext
            
            /// get task from the temporary context to be able to make operations on it like deleting.
            if let task = sender as? Task {
                var registeredObject = vc.context.objectWithID(task.objectID)
                vc.task = (registeredObject as? Task)!
            }
        }
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NTHTaskSearchNavigationController") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func morePressed(sender: AnyObject) {
        let alert = UIAlertController.actionSheet(nil, message: nil)
        alert.addAction(UIAlertAction.normalAction("Move Done to trash", handler: { (action) -> Void in
            for task in self.resultsController.fetchedObjects as! [Task] {
                if task.state == .Done {
                    task.trashed = true
                }
            }
            
            CDHelper.mainContext.save(nil)
            self.resultsController.performFetch(nil)
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction.cancelAction("Cancel", handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /// Mark: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(self.resultsController.fetchedObjects?.count ?? 0, 1)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.resultsController.fetchedObjects?.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell") as! NTHInboxCell
            cell.update(self.resultsController.fetchedObjects![indexPath.row] as! Task)
            cell.selectedBackgroundView = UIView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NTHCenterLabelCell") as! NTHCenterLabelCell
            cell.selectedBackgroundView = UIView()
            cell.label.text = "No tasks"
            cell.label.font = UIFont.NTHAddNewCellFont()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.resultsController.fetchedObjects?.count > 0 {
            self.performSegueWithIdentifier(SegueIdentifier.ShowTask.rawValue, sender: self.resultsController.fetchedObjects![indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    
    /// MARK: NTHCoreDataCloudSyncProtocol
    /*
    func persistentStoreWillChange() {
        
    }
    
    func persistentStoreDidChange() {
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
    */
    func persistentStoreDidReceiveChanges() {
        self.resultsController.performFetch(nil)
        self.tableView.reloadData()
    }
}
