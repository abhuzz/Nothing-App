//
//  InboxCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    @IBOutlet weak var datePlaceLabel: UILabel!
    
    @IBOutlet weak var longDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var datePlaceHeight: NSLayoutConstraint!
    @IBOutlet weak var topGuide: NSLayoutConstraint!
    
    private var initialTopGuideConstant: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setup()
    }
    
    private func setup() {
        if self.initialTopGuideConstant == 0.0 {
            self.initialTopGuideConstant = self.topGuide.constant
        }

        self.thumbnail.animationImages = nil
        
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        self.titleLabel.textColor = UIColor.appBlack()
        
        self.longDescriptionTextView.layoutMargins = UIEdgeInsetsZero
        self.longDescriptionTextView.contentInset = UIEdgeInsetsMake(0, -4, 0, -20)
        self.longDescriptionTextView.textContainerInset = UIEdgeInsetsZero
        self.longDescriptionTextView.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        self.longDescriptionTextView.textColor = UIColor.appBlack()
        
        self.datePlaceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.datePlaceLabel.textColor = UIColor.appWhite186()
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.configureThumbnailView()
    }
    
    private func configureThumbnailView() {
        let radius = 0.5 * (CGRectGetWidth(self.thumbnail.bounds) - 1)
        self.thumbnail.backgroundColor = UIColor.clearColor()
        self.thumbnail.layer.cornerRadius = radius
        self.thumbnail.layer.masksToBounds = true
        self.thumbnail.layer.borderColor = UIColor.appWhite216().CGColor
        self.thumbnail.layer.borderWidth = 1
    }
    
    func update(model: InboxCellVM) {
        self.titleLabel.text = model.title()
        self.longDescriptionTextView.text = model.longDescription()
        self.datePlaceLabel.text = model.dateAndPlace()
        
        self.longDescriptionHeight.constant = self.longDescriptionTextView.proposedHeight
        self.datePlaceHeight.constant = self.datePlaceLabel.proposedHeight
        
        // do only if cell is added to the table view
        if self.superview != nil {
            
            var images = model.connectionsImages()
            if images.count > 0 {
                self.thumbnail.layer.borderWidth = 0
                self.thumbnail.animationImages = images
                self.thumbnail.animationDuration = NSTimeInterval(images.count)
//                self.thumbnail.startAnimating()
            } else {
                self.thumbnail.layer.borderWidth = 1.0
            }
            
            if self.longDescriptionHeight.constant == 0 && self.datePlaceHeight.constant == 0 {
                self.topGuide.constant = self.bounds.midY - self.titleLabel.bounds.midY
            } else {
                self.topGuide.constant = self.initialTopGuideConstant
            }
            
            self.layoutSubviews()
        }
    }
    
    var estimatedHeight: CGFloat {
        let titleHeight = self.titleLabel.proposedHeight
        let longDescriptionHeight = self.longDescriptionHeight.constant
        let datePlaceHeight = self.datePlaceHeight.constant
        
        var margins = (2 * self.initialTopGuideConstant)
        var proposed = titleHeight + longDescriptionHeight + datePlaceHeight + margins
        
        if longDescriptionHeight == 0 && datePlaceHeight == 0 {
            proposed = margins + self.thumbnail.bounds.height
        }
        
        return proposed
    }
}

extension InboxCell {
    class func nib() -> UINib {
        return UINib(nibName: "InboxCell", bundle: NSBundle.mainBundle())
    }
}
