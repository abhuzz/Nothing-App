//
//  DetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.update()
    }
    
    func configureViews() {
        self.view.backgroundColor = UIColor.appWhite250()
        self.navigationBarHeight.constant = 64.0;
        self.containerWidth.constant = self.view.bounds.width
        self.containerHeight.constant = self.view.bounds.height
        self.titleTextView.textContainerInset = UIEdgeInsetsZero
        self.longDescriptionTextView.textContainerInset = UIEdgeInsetsZero
    }
    
    func update() {
        let model = DetailModelView(self.task)
        
        self.titleTextView.text = model.title
        
        self.longDescriptionTextView.text = model.longDescription
        self.longDescriptionTextView.textColor = model.isDescription ? UIColor.appBlack() : UIColor.appWhite216()
        
        self.view.updateConstraintsIfNeeded()
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
