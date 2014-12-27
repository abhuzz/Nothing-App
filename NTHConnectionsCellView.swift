//
//  NTHCollectionCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 17/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

protocol NTHConnectionsCellViewDelegate : class {
    func connectionsCell(cell: NTHConnectionsCellView, didSelectConnection connection: Connection)
}

class NTHConnectionsCellView: UIView {

    /// views
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var connectionsScrollView: UIScrollView!
    
    weak var delegate : NTHConnectionsCellViewDelegate?
    private var connections = [Connection]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.bottomSeparator.backgroundColor = UIColor.NTHWhiteLilacColor()
        self.backgroundColor = UIColor.NTHWhiteSmokeColor()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if (self.subviews.count == 0) {
            let nib = UINib(nibName: "NTHConnectionsCellView", bundle: nil)
            let loadedView = nib.instantiateWithOwner(nil, options: nil).first as NTHConnectionsCellView
            
            /// set view as placeholder is set
            loadedView.frame = self.frame
            loadedView.autoresizingMask = self.autoresizingMask
            loadedView.setTranslatesAutoresizingMaskIntoConstraints(self.translatesAutoresizingMaskIntoConstraints())
            
            for constraint in self.constraints() as [NSLayoutConstraint] {
                var firstItem = constraint.firstItem as NTHConnectionsCellView
                if firstItem == self {
                    firstItem = loadedView
                }
                
                var secondItem = constraint.secondItem as NTHConnectionsCellView?
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
        self.titleLabel.text = title.uppercaseString
    }
    
    func setConnections(connections: [Connection]) {
        self.connections = connections
        
        let height = CGRectGetHeight(self.connectionsScrollView.bounds)
        let margin = 5
        var previousView: UIView?
        var index = 0
        for connection in self.connections {
            /// get and adjust frame
            var frame = CGRectMake(0, 0, height, height)
            if previousView != nil {
                frame.origin.x = CGRectGetMaxX(previousView!.frame) + CGFloat(margin)
            }
            
            /// create button
            var currentView = NTHCircleButton(frame: frame)
            currentView.tag = index
            currentView.backgroundColor = UIColor.clearColor()
            currentView.addTarget(self, action: "_connectionButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            /// set image
            let data = ThumbnailCache.sharedInstance.read(connection.thumbnailKey ?? "")
            
            if let d = data {
                let image = UIImage(data: d)
                currentView.setImage(image, forState: UIControlState.Normal)
            }
            
            self.connectionsScrollView.addSubview(currentView)
            
            /// add constraints
            
            /// width
            let widthConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
            self.connectionsScrollView.addConstraint(widthConstraint)
            
            /// height
            let heightConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
            self.connectionsScrollView.addConstraint(heightConstraint)

            /// Top
            let topConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            self.connectionsScrollView.addConstraint(topConstraint)
            
            /// Bottom
            let bottomConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            self.connectionsScrollView.addConstraint(bottomConstraint)
            
            /// Leading
            if let previousView = previousView {
                let leadingConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: previousView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: CGFloat(margin))
                self.connectionsScrollView.addConstraint(leadingConstraint)
            } else {
                let leadingConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
                self.connectionsScrollView.addConstraint(leadingConstraint)
            }
            
            previousView = currentView
            index++;
        }
        
        /// add trailing constraint
        let trailingConstraint = NSLayoutConstraint(item: previousView!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.connectionsScrollView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.connectionsScrollView.addConstraint(trailingConstraint)
    }
    
    func _connectionButtonTapped(sender: UIButton) {
        self.delegate?.connectionsCell(self, didSelectConnection: self.connections[sender.tag])
    }
    
    func setEnabled(enabled: Bool) {
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
    }
}
