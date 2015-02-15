//
//  NTHTextField.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTextField: UITextField, UITextFieldDelegate {
    var textFieldDidChangeBlock: ((text: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self._addObservers()
    }
    
    private func _addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_textFieldDidChangeNotification", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    private func _removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func _textFieldDidChangeNotification() {
        self.textFieldDidChangeBlock?(text: self.text)
    }

    deinit {
        self._removeObservers()
    }
}
