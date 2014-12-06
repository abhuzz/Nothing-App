//
//  InboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreLocation

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InboxCellDelegate, DetailViewControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var quickInsertView: QuickInsertView!
    @IBOutlet private weak var bottomGuide: NSLayoutConstraint!
    
    enum Identifiers: String {
        case InboxCell = "InboxCell"
        case SearchSegue = "Search"
        case TaskDetailSegue = "TaskDetail"
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
        self.tableView.registerNib(InboxCell.nib(), forCellReuseIdentifier: Identifiers.InboxCell.rawValue)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    private func configureInsertContainer() {
        self.quickInsertView.submitButton.enabled = false
        self.quickInsertView.backgroundColor = UIColor.appWhite250()
        self.quickInsertView.textField.placeholder = "What's in your mind"
        self.quickInsertView.submitButton.setTitle("Add", forState: .Normal)
        self.quickInsertView.didSubmitBlock = { title in [self]
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
            self.performSegueWithIdentifier(Identifiers.CreateTask.rawValue, sender: self.quickInsertView.text)
            self.quickInsertView.finish()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.stopObservingKeyboard()
    }
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tasks = ModelController().allTasks()
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier! == Identifiers.SearchSegue.rawValue {
            let vc = segue.destinationViewController as SearchViewController
            
            if sender != nil {
                vc.searchBarText = sender as String
            }
            
            vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else if segue.identifier! == Identifiers.TaskDetailSegue.rawValue {
            let navVC = segue.destinationViewController as UINavigationController
            let vc = navVC.topViewController as DetailViewController
            vc.task = sender as Task
            vc.delegate = self
        } else if segue.identifier! == Identifiers.CreateTask.rawValue {
            let navVC = segue.destinationViewController as UINavigationController
            let vc = navVC.topViewController as CreateEditViewController
            vc.taskTitle = sender as? String
        }
    }

    @IBAction func searchPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(Identifiers.SearchSegue.rawValue, sender: nil)
    }
    
    /// Mark: UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.InboxCell.rawValue, forIndexPath: indexPath) as InboxCell
        let inboxViewModel = InboxCellViewModel(task)
        cell.update(inboxViewModel)
        cell.delegate = self

        return cell
    }
    
    private var tmpCell: InboxCell!
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let task = self.tasks[indexPath.row]
        
        if (tmpCell == nil) {
            tmpCell = InboxCell.nib().instantiateWithOwner(nil, options: nil).first as InboxCell
            tmpCell.frame.size.width = tableView.bounds.width
        }
        
        tmpCell.update(InboxCellViewModel(task))
        return tmpCell.estimatedHeight
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as InboxCell).update(indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250())
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(Identifiers.TaskDetailSegue.rawValue, sender: self.tasks[indexPath.row])
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.quickInsertView.finish()
    }
    
    /// Mark: InboxCellDelegate
    func cellDidTapActionButton(cell: InboxCell) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let task = self.tasks[indexPath.row]
            task.changeState();
            cell.update(InboxCellViewModel(task))
        }
    }
    
    /// Mark: DetailViewControllerDelegate
    func viewControllerDidSelectHashtag(viewController: DetailViewController, hashtag: String) {
        viewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.performSegueWithIdentifier(Identifiers.SearchSegue.rawValue, sender: hashtag)
        })
    }
}

