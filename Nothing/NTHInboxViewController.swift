//
//  NTHInboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreLocation

class NTHInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NTHInboxCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var quickInsertView: QuickInsertView!
    @IBOutlet private weak var bottomGuide: NSLayoutConstraint!
    
    enum Identifiers: String {
        case InboxCell = "InboxCell"
    }
    
    enum SegueIdentifier: String {
        case TaskDetails = "TaskDetails"
        case CreateTask = "CreateTask"
    }
    
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeKeyboard()
        self.configureTableView()
        self.configureInsertContainer()
        self.navigationItem.title = "Inbox"
    }
    
    private func configureTableView() {
        self.tableView.registerNib(UINib(nibName: "NTHInboxCell", bundle: nil), forCellReuseIdentifier: "NTHInboxCell")
        self.tableView.tableFooterView = UIView()
    }
    
    private func configureInsertContainer() {
        self.quickInsertView.submitButton.enabled = false
        self.quickInsertView.backgroundColor = UIColor.appWhite250()
        self.quickInsertView.textField.placeholder = "What's in your mind"
        self.quickInsertView.submitButton.setTitle("Add", forState: .Normal)
        self.quickInsertView.didSubmitBlock = { [unowned self] title in
            /// create new task
            let task: Task = Task.create(CDHelper.mainContext)
            task.title = title
            
            self.tasks = ModelController().allTasks()
            
            /// refresh ui
            dispatch_async(dispatch_get_main_queue(), { [self, task]
                self.quickInsertView.finish()
                self.tableView.reloadData()

                let index = (self.tasks as NSArray).indexOfObject(task)
                if (index != NSNotFound) {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
            })
        }
        
        self.quickInsertView.didTapMoreBlock = { [self]
            self.performSegueWithIdentifier(SegueIdentifier.CreateTask.rawValue, sender: self.quickInsertView.text)
            self.quickInsertView.finish()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.stopObservingKeyboard()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tasks = ModelController().allTasks()
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier! == SegueIdentifier.TaskDetails.rawValue {
            let vc = segue.destinationViewController as NTHTaskDetailsViewController
            vc.task = sender as Task
        } else if segue.identifier! == SegueIdentifier.CreateTask.rawValue {
            let vc = segue.destinationViewController as NTHCreateTaskController
            vc.configure(self.quickInsertView.text)
            vc.createdTaskBlock = {
                self.tasks = ModelController().allTasks()
                self.tableView.reloadData()
            }
        }
    }
    
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHInboxCell", forIndexPath: indexPath) as NTHInboxCell
        cell.update(NTHInboxCellViewModel(task: task))
        cell.delegate = self

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(SegueIdentifier.TaskDetails.rawValue, sender: self.tasks[indexPath.row])
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.quickInsertView.finish()
    }
    
    /// Mark: Keyboard Notification
    private func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let kbFrame = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
            let animDuration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            
            self.bottomGuide.constant = kbFrame.height
            UIView.animateWithDuration(animDuration, animations: {
                self.quickInsertView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let info = notification.userInfo {
            let animDuration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            self.bottomGuide.constant = 0
            UIView.animateWithDuration(animDuration, animations: {
                self.quickInsertView.layoutIfNeeded()
                self.tableView.layoutIfNeeded()
            })
        }
    }
    
    
    
    /// Mark: NTHInboxCellDelegate
    func cellDidTapActionButton(cell: NTHInboxCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let task = self.tasks[indexPath.row]
        let actionSheet = UIAlertController.selectActionOfTaskActionSheet(task, cell: cell)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}

extension UIAlertController {
    class func selectActionOfTaskActionSheet(task: Task, cell: NTHInboxCell) -> UIAlertController {
        let actionSheet = UIAlertController(title: task.title, message: nil, preferredStyle: .ActionSheet)
        
        /// actions
        if task.state == .Active {
            let markDone = UIAlertAction(title: "Mark as done", style: UIAlertActionStyle.Default) { [unowned task, unowned cell] (action) -> Void in
                task.changeState()
                cell.update(NTHInboxCellViewModel(task: task))
            }
            actionSheet.addAction(markDone)
        } else {
            let markActive = UIAlertAction(title: "Mark as Active", style: UIAlertActionStyle.Default) {[unowned task, unowned cell] (action) -> Void in
                task.changeState()
                cell.update(NTHInboxCellViewModel(task: task))
            }
            actionSheet.addAction(markActive)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
}

