//
//  InboxViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreLocation

class InboxViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var quickInsertView: QuickInsertView!
    @IBOutlet private weak var bottomGuide: NSLayoutConstraint!
    
    enum Identifiers: String {
        case InboxCell = "InboxCell"
        case SearchSegue = "Search"
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
            CDHelper.mainContext.save(nil)
            
            self.tasks = ModelController().allTasks()
            
            /// refresh ui
            dispatch_async(dispatch_get_main_queue(), {
                self.quickInsertView.finish()
                self.tableView.reloadData()
            })
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
        let inboxViewModel = InboxCellVM(task)
        cell.update(inboxViewModel)

        return cell
    }
    
    private var tmpCell: InboxCell!
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let task = self.tasks[indexPath.row]
        
        if (tmpCell == nil) {
            tmpCell = InboxCell.nib().instantiateWithOwner(nil, options: nil).first as InboxCell
            tmpCell.frame.size.width = tableView.bounds.width
        }
        
        tmpCell.update(InboxCellVM(task))
        return tmpCell.estimatedHeight
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250()
    }
}

