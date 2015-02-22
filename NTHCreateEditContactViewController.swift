//
//  NTHCreateEditContactViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 18/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreateEditContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullnameTextField: NTHTextField!
    @IBOutlet weak var phoneNumberTextField: NTHTextField!
    @IBOutlet weak var emailTextField: NTHTextField!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator3: UIView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var context: NSManagedObjectContext!
    var editedContact: Contact?
    var completionBlock: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configureUIColors()
        
        if let contact = self.editedContact {
            self.fullnameTextField.text = contact.name
            self.phoneNumberTextField.text = contact.phone ?? ""
            self.emailTextField.text = contact.email ?? ""
            self._validateDoneButton()
        }
    }
    
    private func _addObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChangeNotification", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    private func _removeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._addObserver()
        self.fullnameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self._removeObserver()
    }
    
    private func _configureUIColors() {
        self.separator1.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator2.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.separator3.backgroundColor = UIColor.NTHTableViewSeparatorColor()
        self.fullnameTextField.textColor = UIColor.NTHHeaderTextColor()
        self.phoneNumberTextField.textColor = UIColor.NTHHeaderTextColor()
        self.emailTextField.textColor = UIColor.NTHHeaderTextColor()
    }
    
    private func _validateDoneButton() {
        self.doneButton.enabled = count(self.fullnameTextField.text) > 0
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let fullName = self.fullnameTextField.text
        let phoneNumber = self.phoneNumberTextField.text
        let emailAdress = self.emailTextField.text
        
        var contact: Contact!
        if let edited = self.editedContact {
            contact = edited
        } else {
            var newEntity: Contact = Contact.create(self.context)
            contact = newEntity
        }
        
        contact.name = fullName
        contact.phone = phoneNumber
        contact.email = emailAdress
        
        self.completionBlock?()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldDidChangeNotification() {
        self._validateDoneButton()
    }
    
    
    /// Mark: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }
}
