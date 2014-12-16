//
//  NTHStateCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHStateCellView: UIView {
    /// views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var statusView: NTHTaskStatusView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.bottomSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.backgroundColor = UIColor.NTHWhiteSmokeColor()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
        self.detailLabel.textColor = UIColor.NTHLinkWaterColor()
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if (self.subviews.count == 0) {
            let nib = UINib(nibName: "NTHStateCellView", bundle: nil)
            let loadedView = nib.instantiateWithOwner(nil, options: nil).first as NTHStateCellView
            
            /// set view as placeholder is set
            loadedView.frame = self.frame
            loadedView.autoresizingMask = self.autoresizingMask
            loadedView.setTranslatesAutoresizingMaskIntoConstraints(self.translatesAutoresizingMaskIntoConstraints())
            
            for constraint in self.constraints() as [NSLayoutConstraint] {
                var firstItem = constraint.firstItem as NTHStateCellView
                if firstItem == self {
                    firstItem = loadedView
                }
                
                var secondItem = constraint.secondItem as NTHStateCellView?
                if secondItem != nil {
                    if secondItem! == self {
                        secondItem = loadedView
                    }
                }
                
                loadedView.addConstraint(NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
            }
            
            return loadedView
        }
        
        return self
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setDetail(detail: String?) {
        self.detailLabel.text = detail
    }
    
    func setEnabled(enabled: Bool) {
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
    }
}
