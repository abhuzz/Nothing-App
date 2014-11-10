//
//  InsertTaskView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 10/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuickInsertView: UIView, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    typealias DidSubmitBlock = (text: String) -> Void
    var didSubmitBlock: DidSubmitBlock?
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if self.subviews.count == 0 {
            let nib = UINib(nibName: "QuickInsertView", bundle: NSBundle.mainBundle())
            let view = nib.instantiateWithOwner(nil, options: nil).first! as QuickInsertView
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
            return view
        }
        
        return self
    }
    
    @IBAction func onSubmitPressed(sender: AnyObject) {
        self.didSubmitBlock?(text: self.textField.text)
    }
    
    @IBAction func textDidChange(sender: AnyObject) {
        self.validateSubmitButton()
    }
    
    private func validateSubmitButton() {
        self.submitButton.enabled = countElements(self.textField.text) > 0
    }
    
    func reset() {
        self.textField.text = ""
        self.validateSubmitButton()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if countElements(self.textField.text) > 0 {
            self.didSubmitBlock?(text: self.textField.text)
        }
        
        self.textField.resignFirstResponder()
        return true
    }
}
