
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
    
    typealias HashtagSelectedBlock = (String) -> ()
    
    @IBOutlet private (set) weak var thumbnailView: UIImageView!
    @IBOutlet private (set) weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var descriptionLabel: UILabel!
    @IBOutlet private (set) weak var datePlaceLabel: UILabel!
    @IBOutlet private weak var descriptionLabelHeight: NSLayoutConstraint!
    
    private var model: TaskCellVM?
    private var tapGesture: UITapGestureRecognizer!
    
    var hashtagSelectedBlock: HashtagSelectedBlock?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.datePlaceLabel.text = ""

        self.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
//        self.enableDebug()
        self.configureThumbnailView()
        self.configureSelectionBackgroundView()
    }
    
    private func configureSelectionBackgroundView() {
        let view = UIView()
        view.backgroundColor = UIColor.appBlueColorAlpha50()
        self.selectedBackgroundView = view
    }
    
    private func configureThumbnailView() {
        let radius = 0.5 * (CGRectGetWidth(self.thumbnailView.bounds) - 1)
        self.thumbnailView.backgroundColor = UIColor.clearColor()
        self.thumbnailView.layer.cornerRadius = radius
        self.thumbnailView.layer.masksToBounds = true
        self.thumbnailView.layer.borderColor = UIColor.appWhite216().CGColor
        self.thumbnailView.layer.borderWidth = 1
    }
    
    private var textMapper: TSTextMapper?
    func handleTap(point: CGPoint) -> Bool {
        var success = false
        if self.textMapper == nil {
            self.textMapper = TSTextMapper(self.descriptionLabel)

            var ranges = [NSRange]()
            for result in self.model!.hashtags {
                ranges.append(result.range)
            }
            
            self.textMapper!.mapTextWithTappableRanges(ranges, text: self.descriptionLabel.text!)
        }
        
        if let text = self.textMapper?.textForPoint(point) {
            success = true
            
            self.hashtagSelectedBlock?(text.value)
        }
        
        return success
    }
    
    private var currentThumbnailImageIndex = 0
    private var thumbnailImages = [UIImage]()
    private var thumbnailTimer: NSTimer?
    private func startThumbnailAnimation() {
        self.stopThumbnailAnimation()
        self.thumbnailTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateThumbnail", userInfo: nil, repeats: true)
    }
    
    func updateThumbnail() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.currentThumbnailImageIndex + 1 < self.thumbnailImages.count {
                self.currentThumbnailImageIndex++
            } else {
                self.currentThumbnailImageIndex = 0
            }
            
            UIView.transitionWithView(self.thumbnailView, duration: 2.0, options: .TransitionCrossDissolve, animations: {
                self.thumbnailView.image = self.thumbnailImages[self.currentThumbnailImageIndex]
            }, completion: nil)
        })
    }
    
    private func stopThumbnailAnimation() {
        self.thumbnailTimer?.invalidate()
        self.thumbnailTimer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textMapper = nil
        self.descriptionLabelHeight.constant = self.descriptionLabel.proposedHeight
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        var wordTapped = false
        if let touch: AnyObject = event.allTouches()?.anyObject() {
            wordTapped = self.handleTap((touch as UITouch).locationInView(self.descriptionLabel))
        }
        
        if !wordTapped {
            super.touchesBegan(touches, withEvent: event)
        }
    }
}

extension TaskCell {
    
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
        
        self.thumbnailImages = model.images
        if self.thumbnailImages.count > 0 {
            self.startThumbnailAnimation()
        }
        
        self.thumbnailView.image = model.images.first
        
        if self.thumbnailView.image != nil {
            self.thumbnailView.layer.borderWidth = 0.0
        }
        
        self.layoutSubviews()
    }
    
    var estimatedHeight: CGFloat {
        self.layoutSubviews()
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        
        var margins = 2 * CGRectGetMinY(self.titleLabel.frame)
        return margins + self.titleLabel.proposedHeight + self.descriptionLabel.proposedHeight + self.datePlaceLabel.proposedHeight
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
