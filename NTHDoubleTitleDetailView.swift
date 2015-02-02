//
//  NTHLocationReminderTitleDetailView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHDoubleTitleDetailView: UIView {
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstDetailLabel: LabelContainer!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondDetailLabel: LabelContainer!
    @IBOutlet weak var bottomSeparator: UIView!
    
    private func nibName() -> String {
        return "NTHDoubleTitleDetailView"
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        return NTHAwakeAfterUsingCoder(aDecoder, nibName: self.nibName())
    }
    
    func setFirstTitleText(text: String) {
        self.firstTitleLabel.text = text.uppercaseString
    }
    
    func setFirstDetailText(text: String) {
        self.firstDetailLabel.text = text
    }
    
    func setSecondTitleText(text: String) {
        self.secondTitleLabel.text = text.uppercaseString
    }
    
    func setSecondDetailText(text: String) {
        self.secondDetailLabel.text = text
    }
    
    func setFirstOnTap(block: LabelTapBlock?) {
        self.firstDetailLabel.onTap = block
    }
    
    func setSecondOnTap(block: LabelTapBlock?) {
        self.secondDetailLabel.onTap = block
    }
    
    func setFirstPlaceholder(text: String) {
        self.firstDetailLabel.placeholder = text
    }
    
    func setSecondPlaceholder(text: String) {
        self.secondDetailLabel.placeholder = text
    }
    
    var isFirstSet: Bool {
        return self.firstDetailLabel.isSet
    }
    
    var isSecondSet: Bool {
        return self.secondDetailLabel.isSet
    }
}
