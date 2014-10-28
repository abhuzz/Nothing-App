//
//  TaskCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet private (set) weak var thumbnailView: UIImageView!
    @IBOutlet private (set) weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var descriptionLabel: UILabel!
    @IBOutlet private (set) weak var datePlaceLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
}

extension TaskCell {
    class func nib() -> UINib {
        return UINib(nibName: "TaskCell", bundle: NSBundle.mainBundle())
    }
}

extension TaskCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.enableDebug()
        
        let radius = 0.5 * (CGRectGetWidth(self.thumbnailView.bounds) - 1)
        self.thumbnailView.layer.cornerRadius = radius
        self.thumbnailView.layer.masksToBounds = true
    }
    
    func update(model: TaskCellVM) {
        self.titleLabel.text = model.title
        self.titleLabel.update(model.titleLabelAttributes)
        
        self.descriptionLabel.text = model.description
        self.descriptionLabel.update(model.descriptionLabelAttributes)
        self.descriptionLabelHeight.constant = self.descriptionLabel.proposedHeight

        self.datePlaceLabel.text = model.datePlaceDescription
        self.datePlaceLabel.update(model.datePlaceLabelAttributes)
        
        self.layoutSubviews()
    }
    
    var estimatedHeight: CGFloat {
        return 2 * CGRectGetMinY(self.titleLabel.frame) + self.titleLabel.proposedHeight + self.descriptionLabel.proposedHeight + self.datePlaceLabel.proposedHeight
    }
}

extension TaskCell {

    func enableDebug() {
        self.contentView.backgroundColor = UIColor.yellowColor()
        self.titleLabel.backgroundColor = UIColor.redColor()
        self.descriptionLabel.backgroundColor = UIColor.greenColor()
        self.datePlaceLabel.backgroundColor = UIColor.blueColor()
    }
}

extension UILabel {
    
    class Attributes {
        var font: UIFont?
        var textColor: UIColor?
        var numberOfLines: Int?
        
        init() {}
    }
    
    var proposedHeight: CGFloat {
        return self.sizeThatFits(CGSize(width: CGRectGetWidth(self.bounds), height: CGFloat.max)).height
    }
    
    func update(attr: Attributes) {
        if let font = attr.font { self.font = font }
        if let textColor = attr.textColor { self.textColor = textColor }
        if let numberOfLines = attr.numberOfLines { self.numberOfLines = numberOfLines }
    }
}