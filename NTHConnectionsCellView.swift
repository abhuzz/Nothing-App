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

class NTHConnectionsCellView: NTHBaseCellView {

    /// outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var connectionsScrollView: UIScrollView!
    
    private var connections = [Connection]()
    
    weak var delegate : NTHConnectionsCellViewDelegate?
    
    override func setupUI() {
        super.setupUI()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
    }
    
    override func nibName() -> String {
        return "NTHConnectionsCellView"
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title.uppercaseString
    }
    
    func setConnections(connections: [Connection]) {
        self.connections = connections
        
        if self.connections.count == 0 {
            return
        }
        
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
}
