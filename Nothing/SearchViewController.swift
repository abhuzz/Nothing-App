//
//  SearchViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 02/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navBarVerticalSpace: NSLayoutConstraint!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    
    private var searchBar: UISearchBar!
    private var tasks: [Task] = [Task]()
    private var allTasks: [Task] = ModelController().allTasks()
    private var searchTimer: NSTimer?

    var searchBarText: String = ""
    
    enum Identifiers: String { case InboxCell = "InboxCell" }
    
    typealias AnimationCompletionBlock = () -> Void

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        /// configure table view
        self.tableView.registerNib(InboxCell.nib(), forCellReuseIdentifier: Identifiers.InboxCell.rawValue)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clearColor()
        
        /// configure no results label
        self.noSearchResultsLabel.textColor = UIColor.appWhite216()

        /// configure search bar
        let windowWidth = UIApplication.sharedApplication().keyWindow!.bounds.width
        let navigationBarContainer = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: self.navigationBar.bounds.height - 20))
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: windowWidth - 10, height: 44.0))
        self.searchBar.showsCancelButton = true
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.delegate = self
        
        navigationBarContainer.addSubview(searchBar)
        
        self.navigationBar.topItem?.titleView = navigationBarContainer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = self.searchBarText
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.present() { [self]
            self.searchBar.becomeFirstResponder()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.startSearchTimer(self.searchBar.text, delay: 0.0)
            })
        }
    }
    
    private func present(completion: AnimationCompletionBlock?) {
        self.navigationBar.alpha = 1.0
        self.navBarVerticalSpace.constant = 0
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.alpha = 1.0
            self.navigationBar.layoutIfNeeded()
            }, completion: { finished in
                if completion != nil {
                    completion!()
                }
            }
        )
    }
    
    private func dismiss(completion: AnimationCompletionBlock?) {
        self.navBarVerticalSpace.constant = -64
        UIView.animateWithDuration(0.2, animations: {
            self.navigationBar.alpha = 0.3
            self.navigationBar.layoutIfNeeded()
            self.tableView.layoutIfNeeded()
            self.tableView.alpha = 0.0
            }, completion: { finished in
                if completion != nil {
                    completion!()
                }
            }
        )
    }
    
    /// Mark: UITableViewDataSource
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
        (cell as InboxCell).update(indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250())
    }

    /// Mark: UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismiss {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.startSearchTimer(searchText)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.startSearchTimer(searchBar.text, delay: 0.0)
    }
    
    func performSearch(timer: NSTimer) {
        let text = timer.userInfo!["phrase"] as String
        var backgroundColor = UIColor.clearColor()
        
        var results = [Task]()
        
        if countElements(text) > 0 {
            backgroundColor = UIColor.appWhite255()
            
            let titlePredicate = NSPredicate(format: "self.title CONTAINS[cd] %@", text)!
            let descriptionPredicate = NSPredicate(format: "self.longDescription CONTAINS[cd] %@", text)!
            let orPredicate = NSCompoundPredicate.orPredicateWithSubpredicates([titlePredicate, descriptionPredicate])
            results = (self.allTasks as NSArray).filteredArrayUsingPredicate(orPredicate) as [Task]
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            if results.count > 0 || text == "" {
                self.noSearchResultsLabel.removeFromSuperview()
            } else {
                self.noSearchResultsLabel.frame = self.tableView.bounds
                (self.tableView as UIScrollView).insertSubview(self.noSearchResultsLabel, atIndex: 10)
            }
            self.tasks = results
            self.tableView.backgroundColor = backgroundColor
            
            self.tableView.reloadData()
        })
    }
    
    func startSearchTimer(phrase: String, delay: NSTimeInterval = 0.3) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.cancelSearchTimer()
            self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "performSearch:", userInfo: ["phrase": phrase], repeats: false)
        })
    }
    
    func cancelSearchTimer() {
        if let timer = self.searchTimer {
            timer.invalidate()
            self.searchTimer = nil
        }
    }
    
    /// Mark: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
