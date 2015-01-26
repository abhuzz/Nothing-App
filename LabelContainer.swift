//
//  LabelContainer.swift
//  Nothing
//
//  Created by Tomasz Szulc on 26/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class LabelContainer: Label {
    var isSet: Bool = false
    
    private var _placeholder: String = ""
    var placeholder: String {
        set {
            _placeholder = newValue
            self.text = newValue
        }
        
        get {
            return _placeholder
        }
    }
    
    override var text: String? {
        set {
            if let t = newValue {
                if t.utf16Count > 0 {
                    self.isSet = true
                    super.text = t
                } else {
                    self.isSet = false
                    super.text = self.placeholder
                }
            }
        }
        
        get {
            return super.text
        }
    }
    
    override var enabled: Bool {
        set {
            super.enabled = newValue
            self.alpha = newValue == true ? 1.0 : 0.4
        }
        
        get {
            return super.enabled
        }
    }
}
