//
//  DetailViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!

    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    private var initialMapHeight: CGFloat = 0.0
    
    @IBOutlet weak var mapViewTopSpace: NSLayoutConstraint!
    private var initialMapViewTopSpace: CGFloat = 0.0
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.update()
    }
    
    func configureViews() {
        self.initialMapHeight = self.mapHeight.constant
        self.initialMapViewTopSpace = self.mapViewTopSpace.constant
        
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
        
        self.locationLabel.text = model.locationReminderDescription
        self.locationLabel.textColor = model.isLocationReminder ? UIColor.appBlack() : UIColor.appWhite216()
        self.mapView.hidden = !model.isLocationReminder
        self.mapHeight.constant = model.isLocationReminder ? self.initialMapHeight : 0
        self.mapViewTopSpace.constant = model.isLocationReminder ? self.initialMapViewTopSpace : 0
        
        self.view.updateConstraints()
        self.locationLabel.updateConstraints()
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
