//
//  InboxCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol InboxCellDelegate {
    func cellDidTapActionButton(cell: InboxCell)
}

class InboxCell: UITableViewCell, UIGestureRecognizerDelegate {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet private weak var datePlaceLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet private weak var longDescriptionHeight: NSLayoutConstraint!
    @IBOutlet private weak var datePlaceHeight: NSLayoutConstraint!
    @IBOutlet private weak var topGuide: NSLayoutConstraint!
    
    private var initialTopGuideConstant: CGFloat = 0.0
    
    var delegate: InboxCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setup()
    }
    
    private func setup() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.appBlueColorAlpha50()
        self.selectedBackgroundView = selectedBackgroundView
        
        if self.initialTopGuideConstant == 0.0 {
            self.initialTopGuideConstant = self.topGuide.constant
        }
        
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        self.titleLabel.textColor = UIColor.appBlack()
        
        self.longDescriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        self.longDescriptionLabel.textColor = UIColor.appBlack()
        self.longDescriptionLabel.opaque = true
        
        self.datePlaceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.datePlaceLabel.textColor = UIColor.appWhite186()
        
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    @IBAction func onActionButtonPressed(sender: AnyObject) {
        self.delegate?.cellDidTapActionButton(self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.didSelect()
        }
    }
    
    func didSelect() {
        self.animatePushViewInside()
        self.setSelected(false, animated: true)
    }
    
    func update(model: InboxCellVM) {        
        self.titleLabel.text = model.title()
        self.longDescriptionLabel.text = model.longDescription()
        self.datePlaceLabel.text = model.dateAndPlace()
        
        self.longDescriptionHeight.constant = self.longDescriptionLabel.proposedHeight
        self.datePlaceHeight.constant = self.datePlaceLabel.proposedHeight
        
        self.actionButton.setImage(model.stateButtonImage, forState: UIControlState.Normal)
        
        // do only if cell is added to the table view
        if self.superview != nil {
            if self.longDescriptionHeight.constant == 0 && self.datePlaceHeight.constant == 0 {
                self.topGuide.constant = self.bounds.midY - self.titleLabel.bounds.midY
            } else {
                self.topGuide.constant = self.initialTopGuideConstant
            }
            
            self.layoutSubviews()
        }
    }
    
    func update(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.titleLabel.backgroundColor = backgroundColor
        self.longDescriptionLabel.backgroundColor = backgroundColor
        self.datePlaceLabel.backgroundColor = backgroundColor
    }
    
    var estimatedHeight: CGFloat {
        let titleHeight = self.titleLabel.proposedHeight
        let longDescriptionHeight = self.longDescriptionHeight.constant
        let datePlaceHeight = self.datePlaceHeight.constant
        
        var margins = (2 * self.initialTopGuideConstant)
        var proposed = titleHeight + longDescriptionHeight + datePlaceHeight + margins
        
        if longDescriptionHeight == 0 && datePlaceHeight == 0 {
            proposed = margins + self.actionButton.bounds.height
        }
        
        return proposed
    }
}

extension InboxCell {
    class func nib() -> UINib {
        return UINib(nibName: "InboxCell", bundle: NSBundle.mainBundle())
    }
}
