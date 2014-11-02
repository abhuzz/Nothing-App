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
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchBar: UISearchBar!
    
    var searchBarText: String = ""
    
    private var tasks: [Task] = [Task]() {
        didSet {
            self.tableView.reloadData()
            self.tableView.backgroundColor = tasks.count > 0 ? UIColor.whiteColor() : UIColor.clearColor()
        }
    }
    
    enum Identifiers: String {
        case TaskCell = "TaskCell"
    }
    
    private var modelCache = TaskCellVMCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(TaskCell.nib(), forCellReuseIdentifier: Identifiers.TaskCell.rawValue)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.configureSearchBar()
    }
    
    func configureSearchBar() {
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
        self.searchBar.becomeFirstResponder()
        self.searchBar.text = self.searchBarText
        self.performSearch(self.searchBar.text)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navBarVerticalSpace.constant = 0
        UIView.animateWithDuration(0.2, animations: {
            self.navigationBar.layoutIfNeeded()
        })
    }
    
    /// Mark: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        var model = self.modelCache.model(task)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TaskCell.rawValue, forIndexPath: indexPath) as TaskCell
        if model == nil {
            model = TaskCellVM(task)
            self.modelCache.add(model!)
        }
        
        cell.update(model!)
        cell.hashtagSelectedBlock = { hashtag in
//            dispatch_async(dispatch_get_main_queue(), { [self]
//                self.performSegueWithIdentifier(SegueIdentifier.Search.rawValue, sender: hashtag)
//            })
        }
        
        println("cellforrow: \(cell.bounds)")
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.appWhite255() : UIColor.appWhite250()
    }

    /// Mark: UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.performSearch(searchText)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.performSearch(searchBar.text)
    }
    
    func performSearch(text: String) {
        if text == "" {
            self.tasks = [Task]()
            return
        }
        
        self.tasks = ModelController().tasksMatching(text)
    }
    
    /// Mark: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
