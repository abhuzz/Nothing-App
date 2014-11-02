//
//  SearchViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 02/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var navBarVerticalSpace: NSLayoutConstraint!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let windowWidth = UIApplication.sharedApplication().keyWindow!.bounds.width
        let navigationBarContainer = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: self.navigationBar.bounds.height - 20))
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: windowWidth - 10, height: 44.0))
        self.searchBar.showsCancelButton = true
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        navigationBarContainer.addSubview(searchBar)

        self.navigationBar.topItem?.titleView = navigationBarContainer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navBarVerticalSpace.constant = 0
        UIView.animateWithDuration(0.3, animations: {
            self.navigationBar.layoutIfNeeded()
        })
    }
}
