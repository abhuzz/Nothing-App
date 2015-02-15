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

class NTHCreateNewPlaceViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var separator1: UIView!
    @IBOutlet private weak var separator2: UIView!
    @IBOutlet private weak var placeDetailsLabel: UILabel!
    @IBOutlet private weak var nameTextField: NTHTextField!
    @IBOutlet private weak var nameTextFieldBottomLayoutGuide: NSLayoutConstraint!
    @IBOutlet private weak var nameTextFieldDefaultBottomLayoutGuide: NSLayoutConstraint!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private var mapTapGesture: UITapGestureRecognizer!
    
    
    var completionBlock: (() -> Void)!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
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
        self.placeDetailsLabel.textColor = UIColor.NTHHeaderTextColor()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        var place: Place = Place.create(self.context)
        place.originalName = ""
        place.customName = self.nameTextField.text
        place.coordinate = (self.mapView.annotations.first as! NTHAnnotation).coordinate
        
        self.completionBlock()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func handleTapOnMap(sender: UITapGestureRecognizer) {
        /// Execute only when gesture is ended
        if (sender.state != UIGestureRecognizerState.Ended) { return }
        
        /// Remove previous annotation
        self.mapView.removeAllAnnotations()
        
        /// Get coordinates
        let touchPoint = sender.locationInView(self.mapView)
        let coordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        /// Create annotation
        self.mapView.addAnnotation(NTHAnnotation(coordinate: coordinate, title: ""))
        self._validateDoneButton()
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if self.nameTextField.editing {
            self.nameTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidChangeNotification() {
        self._validateDoneButton()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.nameTextFieldBottomLayoutGuide.constant = self.nameTextFieldDefaultBottomLayoutGuide.constant + (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.nameTextFieldBottomLayoutGuide.constant = self.nameTextFieldDefaultBottomLayoutGuide.constant
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
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
        return (annotation as! NTHAnnotation).viewForAnnotation()
    }
    
    
    /// Mark: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if self.nameTextField.editing && gestureRecognizer == self.mapTapGesture {
            return false
        }
        return true
    }
}
