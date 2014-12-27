//
//  NTHButton.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCircleButton: UIButton {
    override func drawRect(frame: CGRect) {
        super.drawRect(frame)

        self.clipsToBounds = true
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        self.layer.borderColor = UIColor.NTHWhiteLilacColor().CGColor
        self.layer.borderWidth = 1.0;
    }
}
