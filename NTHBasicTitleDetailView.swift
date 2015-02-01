//
//  NTHBasicTitleDetailView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHBasicTitleDetailView: UIView {
    @IBOutlet var topSeparator: UIView!
    @IBOutlet var bottomSeparator: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: LabelContainer!
    
    private func nibName() -> String {
        return "NTHBasicTitleDetailView"
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        return NTHAwakeAfterUsingCoder(aDecoder, nibName: self.nibName())
    }
    
    func setTitleText(text: String) {
        self.titleLabel.text = text.uppercaseString
    }
    
    func setDetailText(text: String) {
        self.detailLabel.text = text
    }
    
    func setDetailPlaceholderText(text: String) {
        self.detailLabel.placeholder = text
    }
    
    func setOnTap(block: LabelTapBlock?) {
        self.detailLabel.onTap = block
    }
    
    var isSet: Bool {
        return self.detailLabel.isSet
    }
}

