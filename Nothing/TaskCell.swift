//
//  TaskCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

struct WordInstance: Equatable {
    var text: String
    var line: Int
}

func == (lhs: WordInstance, rhs: WordInstance) -> Bool {
    return lhs.text == rhs.text && lhs.line == rhs.line
}

class TaskCell: UITableViewCell {
    
    @IBOutlet private (set) weak var thumbnailView: UIImageView!
    @IBOutlet private (set) weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var descriptionLabel: UILabel!
    @IBOutlet private (set) weak var datePlaceLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    
    private var model: TaskCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.enableDebug()
        self.configureThumbnailView()
        self.configureGestureRecognizer()
    }
    
    private func configureThumbnailView() {
        let radius = 0.5 * (CGRectGetWidth(self.thumbnailView.bounds) - 1)
        self.thumbnailView.backgroundColor = UIColor.clearColor()
        self.thumbnailView.layer.cornerRadius = radius
        self.thumbnailView.layer.masksToBounds = true
        self.thumbnailView.layer.borderColor = UIColor.appWhite216().CGColor
        self.thumbnailView.layer.borderWidth = 1
    }
    
    private func configureGestureRecognizer() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    private var textMapper: TextMapper?
    func handleTap(recognizer: UITapGestureRecognizer) {
        if (recognizer.state == .Ended) {
            let point = recognizer.locationInView(self.descriptionLabel)
            if self.textMapper == nil {
                self.textMapper = TextMapper(font: self.descriptionLabel.font, viewSize: self.descriptionLabel.bounds.size)
                
                // 1
//                self.wordMapper!.mapTextAndMakeAllTappable(self.descriptionLabel.text!)
                
                // 2
                var ranges = [TMTextRange]()
                for result in self.model!.hashtags {
                    ranges.append(result.range)
                }
                
                self.textMapper!.mapTextWithTappableRanges(ranges, text: self.descriptionLabel.text!)
            }
            
            if let text = self.textMapper?.textForPoint(point) {
                println("text = \(text.value)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView(title: nil, message: text.value, delegate: nil, cancelButtonTitle: nil)
                    alert.show()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        alert.dismissWithClickedButtonIndex(0, animated: true)
                    })
                })
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textMapper = nil
        self.descriptionLabelHeight.constant = self.descriptionLabel.proposedHeight
    }
}

extension TaskCell {
    class func nib() -> UINib {
        return UINib(nibName: "TaskCell", bundle: NSBundle.mainBundle())
    }
}

extension TaskCell {
    
    func update(model: TaskCellVM) {
        self.model = model
        self.titleLabel.text = model.title
        self.titleLabel.update(model.titleLabelAttributes)
        
        self.descriptionLabel.update(model.descriptionLabelAttributes)
        self.descriptionLabel.attributedText = model.description
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
