//
//  NTHConnectionCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 31/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHConnectionCellDelegate {
    func cellDidTapClearButton(cell: NTHConnectionCell)
}

class NTHConnectionCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearButtonTrailingConstraint: NSLayoutConstraint!
    
    var delegate: NTHConnectionCellDelegate?
    
    override var layoutMargins: UIEdgeInsets {
        set { super.layoutMargins = newValue }
        get { return UIEdgeInsetsZero }
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        self.delegate?.cellDidTapClearButton(self)
    }
    
    func hideShowButton(hide: Bool, animated: Bool) {
        let animationDuration: Float = animated ? 0.25 : 0
        let animationBlock: () -> () = {
            self.clearButton.alpha = hide ? 0.0 : 1.0
            self.setNeedsUpdateConstraints()
            self.layoutSubviews()
        }
        
        if hide {
            self.clearButtonTrailingConstraint.constant -= self.clearButtonWidthConstraint.constant
        } else {
            self.clearButtonWidthConstraint.constant = 0
        }
        
        UIView.animateWithDuration(NSTimeInterval(animationDuration), animations: animationBlock)
    }
}
