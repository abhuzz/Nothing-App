//
//  NTHBaseCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHBaseCellView: UIView {
    @IBOutlet internal weak var topSeparator: UIView!
    @IBOutlet internal weak var bottomSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    internal func setupUI() {
        self.backgroundColor = UIColor.NTHWhiteSmokeColor()
        self.topSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.bottomSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
    }
    
    internal func nibName() -> String {
        return "NTHBaseCellView"
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        return NTHAwakeAfterUsingCoder(aDecoder, nibName: self.nibName())
    }
    
    func setEnabled(enabled: Bool) {
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
    }
}

