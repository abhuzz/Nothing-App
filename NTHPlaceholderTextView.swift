//
//  NTHPlaceholderTextView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 14/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHPlaceholderTextView: UITextView, UITextViewDelegate {

    @IBInspectable var placeholder: String = ""
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor()
    
    var textValue: String! {
        return self.isPlaceholder ? "" : self.text
    }
    
    private var initialTextColor: UIColor!
    private var isPlaceholder: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialTextColor = self.textColor
        self._setPlaceholder()
        self.delegate = self
        
        /// remove padding
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsetsZero
    }
    
    private var _delegate: UITextViewDelegate?
    override var delegate: UITextViewDelegate? {
        set {
            if newValue == nil {
                super.delegate = newValue
            } else if let value = newValue {
                super.delegate = value
            } else {
                _delegate = newValue
            }
        }
        
        get {
            return super.delegate
        }
    }
    
    
    /// Mark: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        self._removePlaceholder()
        
        if (_delegate?.respondsToSelector("textViewDidBeginEditing") != nil) {
            _delegate?.textViewDidBeginEditing!(textView)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self._setPlaceholder()
        
        if (_delegate?.respondsToSelector("textViewDidEndEditing") != nil) {
            _delegate?.textViewDidEndEditing!(textView)
        }
    }
    
    private func _setPlaceholder() {
        if self.text == "" {
            self.isPlaceholder = true
            self.text = self.placeholder
            self.textColor = self.placeholderColor
        }
    }
    
    private func _removePlaceholder() {
        if self.text == self.placeholder {
            self.isPlaceholder = false
            self.text = ""
            self.textColor = self.initialTextColor
        }
    }
}
