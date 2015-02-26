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
    @IBOutlet private weak var nameTextField: NTHTextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private var mapTapGesture: UITapGestureRecognizer!
    
    var completionBlock: (() -> Void)!
    var context: NSManagedObjectContext!
    var place: Place!
    var editingPlace: Bool = false
    
    
    private var coordinateSet: Bool = false
    
    
    private enum SegueIdentifier: String {
        case ShowMap = "ShowMap"
        case ShowOpenHours = "ShowOpenHours"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        self.mapView.tintColor = UIColor.NTHNavigationBarColor()
        
        /// prepare editing place / view
        if self.editingPlace {
            self.nameTextField.text = place.name
            self._updateWithCoordinate(self.place.coordinate)
        } else {
            var aPlace: Place = Place.createNotInserted(self.context) as Place
            self.place = aPlace
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
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        var annotation: NTHAnnotation!
        for mapAnnotation in self.mapView.annotations as! [MKAnnotation] {
            if mapAnnotation is NTHAnnotation {
                annotation = (mapAnnotation as! NTHAnnotation)
                break
            }
        }
        
        self.place.name = self.nameTextField.text
        self.place.coordinate = annotation.coordinate
        
        if !self.editingPlace {
            self.context.insertObject(self.place)
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
            
            if self.coordinateSet {
                vc.coordinate = self.place.coordinate
            }
            
            vc.completionBlock = { coordinate in
                self.place.coordinate = coordinate
                self._updateWithCoordinate(coordinate)
            }
        } else if segue.identifier == SegueIdentifier.ShowOpenHours.rawValue {
            let vc = segue.destinationViewController as! NTHOpenHoursViewController
        }
    }
    
    private func _updateWithCoordinate(coordinate: CLLocationCoordinate2D) {
        self.mapView.removeAllAnnotations()
        self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: "", subtitle: ""))
        self._setRegionForCoordinate(coordinate)
        self._validateDoneButton()
        self.coordinateSet = true
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
