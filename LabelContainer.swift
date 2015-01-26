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
    var placeholder: String = ""
    
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
}
