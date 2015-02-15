//
//  NTHNonEditableTextField.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHNonEditableTextField: UITextField, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}
