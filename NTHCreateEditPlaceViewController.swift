//
//  NTHCreateNewViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NTHCreateEditPlaceViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var separator1: UIView!
    @IBOutlet private weak var separator2: UIView!
    @IBOutlet private weak var nameTextField: NTHTextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private var mapTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var openHoursSwitch: UISwitch!
    @IBOutlet weak var openHoursTableView: UITableView!
    @IBOutlet weak var openHoursTableViewHeightConstraint: NSLayoutConstraint!
    
    
    var completionBlock: (() -> Void)!
    var context: NSManagedObjectContext!
    var editedPlace: Place?
    var coordinate: CLLocationCoordinate2D!
    
    private enum SegueIdentifier: String {
        case ShowMap = "ShowMap"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.openHoursTableView.registerNib("NTHCenterLabelCell")
        
        self.mapView.tintColor = UIColor.NTHNavigationBarColor()
        
        if let place = self.editedPlace {
            self.coordinate = place.coordinate
            self.mapView.addAnnotation(NTHAnnotation(coordinate: place.coordinate, title: ""))
            self._setRegionForCoordinate(place.coordinate)
            self.nameTextField.text = place.name
            self._validateDoneButton()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._addObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self._removeObservers()
    }
    
    private func _addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChangeNotification", name: UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func _removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func _configureUIColors() {
        self.separator1.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator2.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.openHoursSwitch.tintColor = UIColor.NTHNavigationBarColor()
        self.openHoursSwitch.onTintColor = UIColor.NTHNavigationBarColor()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        let name = self.nameTextField.text
        
        var annotation: NTHAnnotation!
        for mapAnnotation in self.mapView.annotations as! [MKAnnotation] {
            if mapAnnotation is NTHAnnotation {
                annotation = (mapAnnotation as! NTHAnnotation)
                break
            }
        }
        
        let coordinate = annotation.coordinate
        
        if let place = self.editedPlace {
            place.name = name
            place.coordinate = coordinate
        } else {
            var place: Place = Place.create(self.context)
            place.name = name
            place.coordinate = coordinate
        }
        
        self.completionBlock()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func handleTapOnMap(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier(SegueIdentifier.ShowMap.rawValue, sender: nil)
    }

    @IBAction func handleTap(sender: AnyObject) {
        if self.nameTextField.editing {
            self.nameTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidChangeNotification() {
        self._validateDoneButton()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ShowMap.rawValue {
            let vc = segue.destinationViewController as! NTHMapViewController
            if self.coordinate != nil {
                vc.coordinate = self.coordinate
            }
            vc.completionBlock = { coordinate in
                self.coordinate = coordinate
                
                self.mapView.removeAllAnnotations()
                self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: "", subtitle: ""))
                self._setRegionForCoordinate(coordinate)
                self._validateDoneButton()
            }
        }
    }
    
    private func _setRegionForCoordinate(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        self.mapView.setRegion(region, animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        /*
        self.nameTextFieldBottomLayoutGuide.constant = self.nameTextFieldDefaultBottomLayoutGuide.constant + (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        */
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*
        self.nameTextFieldBottomLayoutGuide.constant = self.nameTextFieldDefaultBottomLayoutGuide.constant
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        */
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = self.mapView.annotations.count > 0 && count(self.nameTextField.text) > 0
    }
    
    
    
    /// Mark: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    
    
    /// Mark: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        return (annotation as! NTHAnnotation).viewForAnnotation()
    }
    
    
    
    /// Mark: UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
